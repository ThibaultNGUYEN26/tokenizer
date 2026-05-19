// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Multisig wallet where a transaction is executed after enough owners confirm it.
contract MultiSigWallet {
    // Emitted on direct ETH transfers to the wallet.
    event Deposit(address indexed sender, uint amount, uint balance);
    // Emitted when an owner submits a new transaction for later execution.
    event SubmitTransaction(address indexed owner, uint indexed txIndex, address indexed to, uint value, bytes data);
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    // Solidity generates owners(uint256), not a getter for the full array.
    address[] public owners;
    // Constant-time owner membership check used by onlyOwner.
    mapping(address => bool) public isOwner;
    uint public numConfirmationsRequired;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
    }

    mapping(uint => mapping(address => bool)) public isConfirmed;
    Transaction[] public transactions;

    // Restricts access to wallet owners.
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    // Ensures the requested transaction index exists.
    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "tx does not exist");
        _;
    }

    // Prevents double execution of the same transaction.
    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "tx already executed");
        _;
    }

    // Prevents the same owner from confirming twice.
    modifier notConfirmed(uint _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "tx already confirmed");
        _;
    }

    // Each owner must be unique and non-zero, and the threshold must be valid.
    constructor(address[] memory _owners, uint _numConfirmationsRequired) {
        require(_owners.length > 0, "owners required");
        require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length, "invalid number of required confirmations");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
    }

    // Allows the wallet to receive ETH directly.
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    // Stores a transaction proposal; execution happens in a separate step.
    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        uint txIndex = transactions.length;

        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    // Records one owner's confirmation for a pending transaction.
    function confirmTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    // Executes the call once the confirmation threshold is reached.
    function executeTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(transaction.numConfirmations >= numConfirmationsRequired, "cannot execute tx");

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "tx failed");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    // Lets an owner withdraw a previous confirmation before execution.
    function revokeConfirmation(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed");

        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    // Returns the full owners array in one call.
    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    // Convenience getter for off-chain iteration over transactions.
    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    // Returns the stored fields for one transaction.
    function getTransaction(uint _txIndex) public view returns (address to, uint value, bytes memory data, bool executed, uint numConfirmations)
    {
        Transaction storage transaction = transactions[_txIndex];

        return (transaction.to, transaction.value, transaction.data, transaction.executed, transaction.numConfirmations);
    }
}

// ERC20 token whose initial supply is minted to the multisig wallet.
contract Token42_bonus is ERC20 {
    constructor(uint256 initialSupply, address multisigAddress) ERC20("Token42_bonus", "T42B") {
        require(multisigAddress != address(0), "Invalid multisig address");
        // ERC20 uses 18 decimals by default, so the supply is scaled accordingly.
        _mint(multisigAddress, initialSupply * 10 ** decimals());
    }
}
