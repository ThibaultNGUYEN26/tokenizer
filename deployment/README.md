# Tokenizer
---

## 🦊 Metamask

Create a wallet Metamask:
- Install Metamask on your browser https://metamask.io/download.
- Create an account and log in.

Switch from ETH mainnet to Sepolia:

This is the main page of Metamask:

![image](../src/main_page_metamask.png)

- Select Sepolia

![image](../src/metamask_dropdown.png)
![image](../src/metamask_select_sepolia.png)

---

## 💵 Get free SepoliaETH

Get free sepolia ETH (0.05 SepoliaETH per day)
https://cloud.google.com/application/web3/faucet/ethereum/sepolia

![image](../src/free_sepolia_google_page.png)

---

## 💻 Remix Code

https://remix.ethereum.org/

- Create a `[token_name].sol` file in `contracts/` folder.
- **Compile** the code (it should not display any error).
- Once the code compile, click on **Deploy & run transactions**

![image](../src/deploy_run_transactions.png)

![image](../src/deploy_run_settings.png)

- Select the **Metamask** environnement

![image](../src/deploy_run_select_metamask.png)

- Check that **your contract** is selected

![image](../src/deploy_run_check_contract.png)

- Enter an **initial supply** value
The initial supply is the number of tokens the contract will **mint** when it is **first deploy**

![image](../src/deploy_run_initial_value.png)

- Click on **deploy** and wait for its deployment

![image](../src/deploy_run.png)

Now the contract is deployed, copy its address

![image](../src/deploy_run_copy_address.png)

On https://sepolia.etherscan.io/ paste the contract address in the search bar

![image](../src/etherscan.png)

You can add the number of token minted to your Metamask wallet by importing a new token

![image](../src/metamask_import_tokens.png)

![image](../src/metamask_import_T42.png)

![image](../src/metamask_T42.png)

Now you can also use functions of Etherscan such as `balanceOf` or `totalSupply`. To do that, **publish** the contract.

![image](../src/etherscan_publish_contract.png)

- Go to https://etherscan.io/login?cmd=last, create an account and connect

- Create an **api key**

![image](../src/add_api_key.png)

- Go to **Remix**, add the plugin **Sourcify**

![image](../src/remix_sourcify_plugin.png)

- Verify the **contract**

![image](../src/remix_verify_contract.png)

- Go to **settings** and add the **Etherscan api key** to enable it

![image](../src/remix_add_etherscan_api_key.png)

![image](../src/remix_verify_contract_done.png)

Now you have access to the contract on Etherscan

![image](../src/etherscan_contract.png)

![image](../src/etherscan_balanceof_totalsupply.png)

---

## Deploy the MultiSig Wallet

Do **the exact same process** (with the correct code)
When deploying the smart contract, make a tab with **the wallet addresses** of owners and the number of signatures.
