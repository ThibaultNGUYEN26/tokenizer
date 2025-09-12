# 📝 Token42 Whitepaper

**Name:** Thibnguy
**Version:** 1.0
**Network:** Ethereum Sepolia Testnet
**Standard:** ERC-20

---

## 1. Abstract

Token42 (T42) is a fungible ERC-20 token deployed on the Ethereum Sepolia testnet.
It was created as part of a project to explore blockchain technology, smart contracts, and token deployment.
The token serves as a **learning and demonstration asset**: it carries no monetary value but illustrates the practical process of designing, deploying, and verifying a token on Ethereum.

---

## 2. Introduction

Blockchain enables the creation of decentralized, transparent, and tamper-proof digital assets.
Among these, tokens represent programmable assets that can serve as currencies, governance instruments, or rewards inside applications.

**Token42** demonstrates how a simple ERC-20 token can be designed, deployed, and integrated into tools such as MetaMask and Etherscan.
It provides a practical example of the complete lifecycle of a token, from coding to deployment and usage.

---

## 3. Technical Specifications

- **Blockchain**: Ethereum (Sepolia Testnet)
- **Token Standard**: ERC-20
- **Programming Language**: Solidity
- **Development Tools**: Remix IDE, OpenZeppelin, MetaMask, Etherscan
- **Contract Name**: Token42
- **Symbol**: T42
- **Decimals**: 18 (default ERC-20)
- **Initial Supply**: 1000 T42 (minted to deployer’s address)
- **Contract Address**: `0x...` (deployed on Sepolia)
- **Explorer**: [Sepolia Etherscan](https://sepolia.etherscan.io/)

---

## 4. Features and Functionality

Token42 implements the **standard ERC-20 interface**, making it fully compatible with wallets, explorers, and decentralized applications.

Core functions include:
- `totalSupply()` → total minted supply of tokens.
- `balanceOf(address)` → token balance of a wallet.
- `transfer(address, amount)` → transfer tokens between wallets.
- `approve(address, amount)` → authorize another account to spend tokens.
- `transferFrom(address, address, amount)` → move tokens on behalf of another account.

These functions ensure interoperability across the Ethereum ecosystem.

---

## 5. Wallet Integration

Token42 can be used directly in MetaMask:
1. Select the **Sepolia** network.
2. Import the token contract address.
3. The T42 balance becomes visible.

This integration allows transfers and interaction with decentralized applications.

---

## 6. Use Cases

Although Token42 has no economic value, it illustrates how tokens can be applied in real-world contexts:

- **Educational Tool** → teaching blockchain fundamentals.
- **Prototype Token** → testing governance, rewards, or digital economy features.
- **Technical Showcase** → demonstrating contract deployment and verification.

Potential applications in real scenarios include:
- User reward systems.
- Governance and voting mechanisms.
- Internal currencies for platforms or applications.

---

## 7. Deployment Summary

The deployment process followed these steps:
1. Smart contract written in Solidity with OpenZeppelin’s ERC-20 implementation.
2. Compilation and deployment via Remix IDE, with MetaMask as wallet provider.
3. Contract verified and published on Sepolia Etherscan for transparency.
4. Token imported into MetaMask for wallet interaction.
5. Testing through functions such as `totalSupply`, `balanceOf`, and `transfer`.

---

## 8. Usage

Check `totalSupply`:
- Go to Contract then Read Contract on Etherscan.

Check the `balanceOf` a wallet:
- Same go to Contract then Read Contract on Etherscan and add the wallet address.

Transfer T42 to a wallet:
- Go to Write contract, add the wallet address, then the number of token you want to send (you have to add 10^18 zeros).

---

## 9. How to Use MultiSig with Token42

The **MultiSigWallet** ensures that no single owner can move Token42 tokens alone.
Every transfer or action must be **submitted**, **confirmed** by multiple owners, and then **executed** once the required number of confirmations is reached.

### 1. Deploy MultiSigWallet
- Deploy the `MultiSigWallet` contract first.
- Provide:
  - A list of owner addresses (e.g. `["0x123...", "0x456..."]`).
  - The number of confirmations required (e.g. `2`).

### 2. Deploy Token42
- Copy the multisig contract address.
- Deploy `Token42` with:
  - `initialSupply = 1000`
  - `multisigAddress = [address of MultiSigWallet]`

The entire supply of **1000 T42** is minted directly into the MultiSigWallet.

### 3. Submit a Token Transfer
- An owner calls `submitTransaction()` on the MultiSigWallet:
  - `_to`: recipient address.
  - `_value`: `0` (no ETH, only token call).
  - `_data`: the ABI-encoded function call for Token42 (e.g. `transfer(address,uint256)`).

Example (to transfer 10 T42):
- Use Remix → “submitTransaction”
- `_to`: Token42 contract address.
- `_data`: ABI for `transfer("0xRecipient", 10 * 10^18)`.

### 4. Confirm the Transaction
- Each additional owner must call `confirmTransaction(txIndex)`.
- Once the required number of confirmations is reached, the transaction is ready.

### 5. Execute the Transaction
- Any owner can then call `executeTransaction(txIndex)`.
- If enough confirmations exist, the transfer will execute.
- The recipient receives their T42 tokens.

### Example Workflow
1. Alice, Bob, and Charlie are owners.
2. Required confirmations: `2`.
3. Alice submits a transaction to transfer 50 T42 to Dave.
4. Bob confirms the transaction.
5. Alice (or Bob) executes it.
6. Dave receives 50 T42.

---

## 10. Conclusion

Token42 demonstrates the **end-to-end lifecycle of a fungible token** on Ethereum:
- Design and implementation in Solidity.
- Deployment on a testnet (Sepolia).
- Verification on Etherscan.
- Integration into MetaMask for wallet interaction.
