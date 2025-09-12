// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importing the standard ERC20 implementation from OpenZeppelin.
// OpenZeppelin provides secure and community-vetted smart contract libraries.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Declare the contract, inheriting the functionality of OpenZeppelin's ERC20.
contract Token42 is ERC20 {

    /*
      The constructor is executed once when the contract is deployed.
      initialSupply: define how many tokens are created at deployment.
      ERC20("Token42", "T42") sets:
        - "Token42": token's name
        - "T42": the token's symbol (short identifier, like USD or BTC)
    */
    constructor(uint256 initialSupply) ERC20("Token42", "T42") {

        /*
          Mint the initial supply of tokens and assign them to the deployer (msg.sender).
          _mint: provided by OpenZeppelin's ERC20 contract.
          Multiplication by 10 ** decimals() adjusts for the token's decimal places.
          By default, ERC20 uses 18 decimals (like ETH).
        */
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}
