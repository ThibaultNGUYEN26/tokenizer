// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importing the standard ERC20 implementation from OpenZeppelin.
// OpenZeppelin provides secure and community-vetted smart contract libraries.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// A simple multi-signature wallet.
// Multiple owners can submit, confirm, revoke, and execute transactions.
// A transaction executes only after reaching the required number of confirmations.
contract MultiSigWallet {
    // Emitted when the contract receives ETH.
    event Deposit(address indexed sender, uint amount, uint balance);
    // Emitted when an owner submits a new transaction proposal.
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );
    // Emitted when an owner confirms a transaction.
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    // Emitted when an owner revokes their confirmation.
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    // Emitted when a confirmed transaction is executed.
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    // List of wallet owners.
    address[] public owners;
    // Quick lookup to check if an address is an owner.
    mapping(address => bool) public isOwner;
    // Number of confirmations required to execute a transaction.
    uint public numConfirmationsRequired;

    // Transaction data stored for each submitted transaction.
    struct Transaction {
        // Destination address for the call.
        address to;
        // ETH value to send with the call (in wei).
        uint value;
        // Calldata to send with the call (function selector + arguments).
        bytes data;
        // Whether the transaction has been executed.
        bool executed;
        // How many confirmations this transaction currently has.
        uint numConfirmations;
    }

    // mapping from tx index => owner => bool
    mapping(uint => mapping(address => bool)) public isConfirmed;

    // Storage for all submitted transactions.
    Transaction[] public transactions;

    /*
      Restricts a function to wallet owners only.
      - Reverts if msg.sender is not an owner.
    */
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    /*
      Ensures the referenced transaction index exists.
      - Reverts if _txIndex is out of bounds.
    */
    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "tx does not exist");
        _;
    }

    /*
      Ensures the transaction has not already been executed.
    */
    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "tx already executed");
        _;
    }

    /*
      Ensures the caller has not already confirmed the transaction.
    */
    modifier notConfirmed(uint _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "tx already confirmed");
        _;
    }

    /*
      Constructor: sets up the owners and required confirmations.
        - _owners: list of unique, non-zero owner addresses
        - _numConfirmationsRequired: threshold to execute a transaction
      Validations:
        - At least one owner
        - Required confirmations > 0 and <= number of owners
        - Each owner must be unique and non-zero
    */
    constructor(address[] memory _owners, uint _numConfirmationsRequired) {
        require(_owners.length > 0, "owners required");
        require(
            _numConfirmationsRequired > 0 &&
            _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        // Set the threshold required to execute a transaction.
        numConfirmationsRequired = _numConfirmationsRequired;
    }

    // Accept ETH transfers sent to this contract.
    // Emits a Deposit event including the new balance.
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    /*
      Submit a new transaction proposal.
        - _to: target address to call
        - _value: ETH amount (wei) to send
        - _data: calldata (encoded function selector + args)
      Notes:
        - Only owners can submit
        - Transaction is not executed immediately; it must be confirmed
    */
    function submitTransaction(
        address _to,
        uint _value,
        bytes memory _data
    ) public onlyOwner {
        // The index where the new transaction will be stored.
        uint txIndex = transactions.length;

        // Store the new transaction with 0 confirmations and not executed.
        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );

        // Notify off-chain listeners that a new transaction was submitted.
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    /*
      Confirm a transaction.
      Requirements:
        - Caller must be an owner
        - Transaction must exist and not be executed
        - Caller must not have already confirmed it
    */
    function confirmTransaction(
        uint _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex) {
        // Increase confirmations and mark caller as having confirmed.
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    /*
      Execute a confirmed transaction.
      Requirements:
        - Caller must be an owner
        - Transaction must exist and not be executed
        - Confirmations must meet or exceed the required threshold
      Effects:
        - Marks transaction as executed and performs the call
    */
    function executeTransaction(
        uint _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(
            transaction.numConfirmations >= numConfirmationsRequired,
            "cannot execute tx"
        );

        transaction.executed = true;

        // Perform the external call with the specified value and data.
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "tx failed");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    /*
      Revoke a previously made confirmation by the caller.
      Requirements:
        - Caller must be an owner
        - Transaction must exist and not be executed
        - Caller must have already confirmed the transaction
    */
    function revokeConfirmation(
        uint _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed");

        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    // Get the list of wallet owners.
    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    // Get total number of submitted transactions.
    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    /*
      Read a transaction by index.
      Returns:
        - to: destination address to call
        - value: ETH to send (wei)
        - data: calldata (bytes)
        - executed: whether it has been executed
        - numConfirmations: current confirmation count
    */
    function getTransaction(
        uint _txIndex
    )
    public
    view
    returns (
        address to,
        uint value,
        bytes memory data,
        bool executed,
        uint numConfirmations
    )
    {
        Transaction storage transaction = transactions[_txIndex];

        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}

// Declare the contract, inheriting the functionality of OpenZeppelin's ERC20.
contract Token42 is ERC20 {

    /*
      The constructor is executed once when the contract is deployed.
      initialSupply: define how many tokens are created at deployment.
      ERC20("Token42", "T42") sets:
        - "Token42": token's name
        - "T42": the token's symbol (short identifier, like USD or BTC)
    */
    constructor(uint256 initialSupply, address multisigAddress) ERC20("Token42", "T42") {
        require(multisigAddress != address(0), "Invalid multisig address");
        /*
          Mint the initial supply of tokens and assign them to the deployer (msg.sender).
          _mint: provided by OpenZeppelin's ERC20 contract.
          Multiplication by 10 ** decimals() adjusts for the token's decimal places.
          By default, ERC20 uses 18 decimals (like ETH).
        */
        _mint(multisigAddress, initialSupply * 10 ** decimals());
    }
}
