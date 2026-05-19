# Tokenizer
---

## Understanding

### 🔑 What is a Token?

A **token** is a **digital asset** that exists **on top of a blockchain**.
It’s not its own blockchain (like Bitcoin or Ethereum), but rather something created *inside* another blockchain.

### ⛓️ What is a Blockchain?

A **blockchain** is a **shared digital ledger** (like a database) that is **decentralised** (it's not stored on one computer, but on thousands of nodes), **immutable** (once the data is written, it cannot be changed or deleted), **organised in block** (instead of handling each transaction one by one, they are grouped into "blocks"), **chained together** (each block references the previous one, making tampering impossible), **secured by consensus** (all nodes agree on which transactions are valid (via Proof of Work, Proof of Stake, etc.)).

The **blockchain** is the operating system (e.g. Etherum)
The **token** is the application running on that operating system (e.g. USDT, SHIBA, etc.)

### 🪙 Two Big Families of Tokens

- Fungible Tokens (ERC-20 standard on Ethereum)
  - All units are identical (e.g. 1 USDT = 1 USDT)
  - Used for currencies, utility tokens, gouvernance tokens
- Non-Fungible Tokens (NTFs, ERC-721/1155 standards)
  - Each token is unique (e.g. NFT artwork, game items)
  - Used for collectibles, digital identity, gaming.

### ⚙️ How Tokens Work

A token is defined by a **smart contract** (a program on the blockchain).
The smart contract keeps track on the token: **total supply** (how many tokens exist), **balances** (who owns how much), **transfers** (when tokens move from one address to another).
The most common rules are defined in **standards** (like ERC-20).

---

## Testnet

### 🌍 Why Choose Ethereum (ERC-20)

Ethereum with the ERC-20 standard is the most common choice for creating tokens. ERC-20 is the **oldest and most widely used token model**, supported by almost all wallets, dApps, and exchanges. It guarantees compatibility and follows rules that are universally recognised.

The Ethereum **ecosystem provides strong tooling** such as Hardhat, Remix, and OpenZeppelin, along with plenty of documentation and community resources. This makes development easier and faster. ERC-20 is also the foundation of DeFi: most stablecoins and governance tokens use it, which means understanding ERC-20 is enough to cover the majority of today’s token economy.

Another advantage is the use of **Ethereum testnets like Sepolia or Holesky**. They allow deploying contracts without real ETH and are connected to Etherscan explorers. With Etherscan, contracts can be verified and interacted with directly, ensuring transparency and easy proof of work.

Finally, Ethereum and ERC-20 remain the **industry standard**. Most professional blockchain projects still use this model, making it **the most relevant and reliable choice**.

### 🚀 Why Choose Sepolia

Sepolia is one of **the official Ethereum testnets** maintained by the community. It is **lighter and faster** than Holesky, which makes it more practical for development and testing.

It uses **Proof of Stake** like **Ethereum mainnet**, so it reflects the real behaviour of Ethereum while avoiding high gas fees. Test ETH can be obtained **for free through faucets**, making experimentation accessible.

Sepolia is also **fully supported** by Etherscan, allowing contracts to be explored, verified, and interacted with just like on mainnet. This ensures a smooth transition from testing to real-world deployment.

For these reasons, Sepolia is the preferred choice for testing ERC-20 tokens in this project.

### 📜 Why Solidity

**Solidity** is the main programming language for writing smart contracts on **Ethereum**. It was designed specifically for the **Ethereum Virtual Machine (EVM)** and is the **industry standard** for creating **ERC-20 tokens**. Its syntax is **similar to JavaScript**, which makes it easier to learn for developers with web backgrounds. Using Solidity ensures **full compatibility** with Ethereum and its testnets, as well as access to a wide range of libraries such as **OpenZeppelin**.

### 💻 Why Remix

**Remix** is an **online IDE** dedicated to Solidity development. It does not require any local setup, making it quick and easy to start writing, compiling, and deploying smart contracts directly from the browser. It integrates seamlessly with **MetaMask**, supports Ethereum testnets such as **Sepolia**, has courses to learn, and provides **debugging tools** for contract testing. Remix is the **simplest and most accessible choice** for creating and deploying an ERC-20 token in a learning environment.

Compared to other tools:

- **ChainIDE** offers templates for ERC-20 and NFT contracts, but these ready-made codes reduce the learning value. Remix encourages direct interaction with Solidity, ensuring a better understanding of how the token works.
- **Truffle** is a powerful framework for managing complex deployments and automated testing. However, it requires a full local setup and additional configuration, which is unnecessary for a simple token project.
- **Hardhat** is widely used in professional environments for automation and advanced debugging. While very powerful, it adds extra layers of setup and scripts that make it heavier for this kind of project.

**Remix strikes the right balance**: it is official, lightweight, well-documented, and focuses directly on Solidity development without the overhead of more advanced frameworks.

---


## Smart Contract

### 🤖 What is a Smart Contract?

A **smart contract** is a self-executing program stored on the blockchain. It automatically enforces rules and actions defined in its code, without the need for intermediaries. Smart contracts can hold and transfer assets (like tokens), manage balances, and execute transactions when certain conditions are met. Once deployed, their logic cannot be changed, ensuring transparency and trust. In the context of tokens, the smart contract defines how tokens are created, transferred, and managed on the blockchain.

### 🦊 Why MetaMask

To deploy a smart contract, a **wallet** is needed that can hold **ETH (or test ETH)**. **MetaMask** is the most widely used wallet for Ethereum and **EVM-compatible blockchains**. It acts as a **bridge between the user and the blockchain** by managing **private keys** and **signing transactions**. MetaMask is available as a **browser extension and mobile app**, making it easy to connect directly with development tools such as **Remix**.

It supports testnets like **Sepolia**, where **free test ETH** can be obtained from **faucets** to pay for gas fees during deployment. Using MetaMask ensures **secure interaction** with the blockchain, **transparent transaction history**, and full compatibility with Ethereum explorers such as **Etherscan**.

### 🔍 Why Etherscan

**Etherscan** is the main **blockchain explorer** for Ethereum and its testnets. It allows **verification of smart contracts**, transparent display of **token information** such as **supply** and **holders**, and direct interaction with contract functions like `transfer` or `balanceOf`. Using Etherscan provides **clear proof of deployment** and ensures that the token can be **inspected and tested** without building a custom interface.
