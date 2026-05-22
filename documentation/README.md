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

## 9. How to Use Token42_bonus

`Token42_bonus` is now a **single contract** that combines an ERC-20 token with a built-in multisig approval flow.
The token treasury is minted to the contract itself, and outgoing transfers must be **submitted**, **confirmed** by multiple owners, and then **executed**.

### 1. Deploy Token42_bonus
- Deploy the `Token42_bonus` contract.
- Provide:
  - `initialSupply` (for example `1000`)
  - a list of owner addresses (for example `["0x123...", "0x456...", "0x789..."]`)
  - the number of confirmations required (for example `2`)

The entire supply of **1000 T42B** is minted into the `Token42_bonus` contract treasury, not directly to a personal wallet.

### 2. Submit a Transfer Request
- An owner calls `submitTransfer(_to, _amount)` on `Token42_bonus`.
- `_to`: recipient wallet address.
- `_amount`: token amount using 18 decimals.

Examples:
- `1 T42B` = `1000000000000000000`
- `10 T42B` = `10000000000000000000`
- `50 T42B` = `50000000000000000000`

### 3. Confirm the Transfer
- Owners call `confirmTransfer(txIndex)`.
- Each owner can confirm a given transfer request only once.
- Once the required number of confirmations is reached, the transfer is ready to be executed.

### 4. Execute the Transfer
- Any owner can call `executeTransfer(txIndex)`.
- If enough confirmations exist and the treasury holds enough tokens, the transfer executes.
- The recipient then receives their T42B tokens.

### 5. Useful Read Functions
- `getOwners()` returns the owner list.
- `getTransferRequestCount()` returns the number of submitted transfer requests.
- `getTransferRequest(txIndex)` returns the recipient, amount, execution state, and number of confirmations.
- `balanceOf(address)` checks the balance of a wallet or of the contract treasury.

### Example Workflow
1. Alice, Bob, and Charlie are owners.
2. Required confirmations: `2`.
3. Alice submits a transfer of `50 T42B` to Dave with `submitTransfer(Dave, 50000000000000000000)`.
4. Bob confirms it with `confirmTransfer(0)`.
5. Alice or Bob executes it with `executeTransfer(0)`.
6. Dave receives `50 T42B`.

---

## 10. Conclusion

Token42 demonstrates the **end-to-end lifecycle of a fungible token** on Ethereum:
- Design and implementation in Solidity.
- Deployment on a testnet (Sepolia).
- Verification on Etherscan.
- Integration into MetaMask for wallet interaction.
