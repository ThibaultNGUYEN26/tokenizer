// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// ERC20 token whose treasury is held by the token contract itself.
// Owners must confirm outgoing transfers before execution.
contract Token42_bonus is ERC20 {
    event SubmitTransfer(address indexed owner, uint indexed txIndex, address indexed to, uint256 amount);
    event ConfirmTransfer(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransfer(address indexed owner, uint indexed txIndex);

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public numConfirmationsRequired;

    struct TransferRequest {
        address to;
        uint256 amount;
        bool executed;
        uint256 numConfirmations;
    }

    mapping(uint256 => mapping(address => bool)) public isConfirmed;
    TransferRequest[] public transferRequests;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transferRequests.length, "tx does not exist");
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        require(!transferRequests[_txIndex].executed, "tx already executed");
        _;
    }

    modifier notConfirmed(uint256 _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "tx already confirmed");
        _;
    }

    constructor(
        uint256 initialSupply,
        address[] memory _owners,
        uint256 _numConfirmationsRequired
    ) ERC20("Token42_bonus", "T42B") {
        require(_owners.length > 0, "owners required");
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
        _mint(address(this), initialSupply * 10 ** decimals());
    }

    // Stores a transfer proposal; execution happens in a separate step.
    function submitTransfer(address _to, uint256 _amount) public onlyOwner {
        require(_to != address(0), "invalid recipient");
        require(_amount > 0, "amount required");

        uint256 txIndex = transferRequests.length;
        transferRequests.push(
            TransferRequest({
                to: _to,
                amount: _amount,
                executed: false,
                numConfirmations: 0
            })
        );

        emit SubmitTransfer(msg.sender, txIndex, _to, _amount);
    }

    // Records one owner's confirmation for a pending transfer.
    function confirmTransfer(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        TransferRequest storage transferRequest = transferRequests[_txIndex];
        transferRequest.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransfer(msg.sender, _txIndex);
    }

    // Executes the transfer once the confirmation threshold is reached.
    function executeTransfer(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        TransferRequest storage transferRequest = transferRequests[_txIndex];

        require(
            transferRequest.numConfirmations >= numConfirmationsRequired,
            "cannot execute tx"
        );
        require(balanceOf(address(this)) >= transferRequest.amount, "insufficient treasury");

        transferRequest.executed = true;
        _transfer(address(this), transferRequest.to, transferRequest.amount);

        emit ExecuteTransfer(msg.sender, _txIndex);
    }

    // Lets an owner withdraw a previous confirmation before execution.
    function revokeConfirmation(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        TransferRequest storage transferRequest = transferRequests[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed");

        transferRequest.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransferRequestCount() public view returns (uint256) {
        return transferRequests.length;
    }

    function getTransferRequest(uint256 _txIndex)
        public
        view
        returns (address to, uint256 amount, bool executed, uint256 numConfirmations)
    {
        TransferRequest storage transferRequest = transferRequests[_txIndex];

        return (
            transferRequest.to,
            transferRequest.amount,
            transferRequest.executed,
            transferRequest.numConfirmations
        );
    }
}
