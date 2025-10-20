# Lancer Protocol

![banner](images/banner.png "Banner")

🌐 An open-source protocol for building on-top decentralized applications (dApps) on the Ethereum blockchain. It's designed for developers to create and deploy their own dApps with on-chain escrows, payments and dispute resolution systems.

## Problem
Centralized marketplace platforms charge high fees, in case of cross-border payments they can be delayed for several days and have an average cost of 6.04%. While they rely on dispute processes centralized in the same platforms.

## Solution
**Lancer Protocol** provides the foundational infrastructure for decentralized marketplaces and payment applications.
It allows developers to integrate secure escrow mechanisms, on-chain dispute resolution, and programmable payment flows directly into their dApps, without rebuilding these components from scratch. While obtaining:
- **Low Fees**: Minimal fees since we allow a revenue model based on yield through lending protocols as Aave.
- **Fast Payments**: Sellers or freelancers can withdraw instantly to their wallets, avoiding conversion or cross-border bank delays.
- **Free Payments**: Transfers through Ethereum have minimal costs even for cross-border payments.
- **Trustless Escrow**: Smart contracts lock funds, releasing only on verified conditions, reducing dispute bias.
- **Transparency**: The escrow and voting systems are open-source and immutable while all transactions are public on Etherscan.

🧭 Overview

At its core, Lancer Protocol standardizes how digital agreements and payments are handled on-chain:

**Escrow Contracts** hold funds in PYUSD until both parties are satisfied.

**Dispute Resolution Layer** enables verifiable and transparent dispute handling, optionally powered by decentralized oracles or third-party arbitration modules.

**Modular Architecture** developers can plug in or extend modules (reputation systems, insurance, arbitration, AI agents, etc.) for their use case.

This modular approach transforms Lancer Protocol into a composable backend for trustless applications, ideal for:

Freelance & gig marketplaces
DAO bounty platforms
AI-to-AI or agentic payment flows
Peer-to-peer commerce
Web3 escrow-as-a-service infrastructure

⚙️ How It Works

- Escrow Creation
A buyer or dApp creates an escrow, specifying deal conditions, seller and the amount in **PYUSD**.
Funds are locked securely in the contract until release or dispute resolution.

- Safe Payments
Payments remain in escrow until both sides approve, ensuring fairness.
Developers can build custom logic around deadlines, milestones, or deliverables.

- Dispute Handling
If a disagreement occurs, users can trigger a dispute through DisputeManager.
The protocol emits verifiable events, which can be indexed via Envio HyperIndex or settled cross-chain with Avail.

- Smart Contract Transparency (**Blockscout**)
Lancer integrates Blockscout for allowing anyone to explore contract code, transactions, and interactions directly from the Lancer frontend.

- Data Indexing (**Envio**)
All on-chain events are indexed in real-time using Envio HyperIndex, allowing instant access to user escrows, dispute status, and analytics dashboards.



## ✅ Setup

### Requirements

You need to install the following tools:

- [Node (>= v20.18.3)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))

### Quickstart

To get started follow those steps:

1. Install dependencies:

```
yarn install
```

2. Run a local network in the first terminal:

```
yarn chain
```

This command starts a local Ethereum network using Foundry. You can customize the network configuration in `packages/foundry/foundry.toml`.

3. On a second terminal, deploy the test contract:

```
yarn deploy
```

This command deploys a test smart contract to the local network. If you want to deploy on a real testnet you can execute:

```
forge script script/DeploySepolia.s.sol \
  --rpc-url sepolia \
  --private-key $SEPOLIA_DEPLOYER_KEY \
  --broadcast
```

4. To start the frontend run:

```
yarn start
```

Visit the app on: `http://localhost:3000`. You can interact with your smart contract going to `Lancer App` page.

5. For running smart contract test use 
   
```
yarn foundry:test
```



## ✅ Roadmap

### ⚡ **Lancer Protocol**

- [x] Define smart contracts structure and flow
- [x] Implement payment system integrating **PYUSD**
- [x] Deploy smart contracts to testnet (Sepolia and Anvil)  
- [x] Write unit and integrations tests for all the contracts
- [x] Implement an on-chain reputation scoring system based on previous disputes results
- [x] Implement disputes system emitting indexed events for **Envio**
- [x] Verify contracts on **Blockscout** transparency  
- [x] Integrate **Envio HyperIndex** to index Escrow and Dispute events in real time  
- [x] Build a Dispute Dashboard to visualize indexed disputes via **Envio HyperIndex**  
- [x] Implement fee model for protocol sustainability
- [ ] Implement a tier system for judges, based on reputation
- [ ] Develop Lancer Protocol's SDK and APIs
- [ ] Add `CrossChainExecutor` for cross-chain payments  
- [ ] Document ABI interfaces and protocol workflows for developers  
- [ ] Build analytics dashboards using **Envio HyperIndex** for usage metrics  
- [ ] Launch a developer documentation portal with examples and tutorials  
- [ ] Implement a random selection of the judges for the specific dispute
- [ ] Implement private voting mechanism with vote reveal only after conclusion
- [ ] Launch developer documentation portal with tutorials
- [ ] Add protocol upgradeability

### 🛠️ **Lancer Factory**

- [x] Define smart contracts structure and flow 
- [x] Link Factory with Protocol contract
- [x] Add Factory metadata registry (track deployed marketplaces and owners)
- [ ] Deploy marketplace instances deterministically (CREATE2)
- [ ] Enable upgrade mechanism for future marketplace templates

### 🛒 **Lancer Market**

- [x] Deploy **Lancer Market** as an example dApp using Lancer Factory 
- [x] Implement payment system with **PYUSD**
- [x] Integrate wallet connection (MetaMask or RainbowKit) with **PYUSD** payment support  
- [x] Implement basic job posting and hiring flow between `payers` and `beneficiaries`  
- [x] Allow users to create and manage their on-chain escrows through the UI  
- [ ] Implement milestones system for `deals`
- [ ] Build a user dashboard to view active escrows, completed jobs, and earnings  
- [ ] Add real-time notifications for escrow creation, release, and dispute resolution  
- [ ] Allow multiple tokens payments by converting them to **PYUSD** when sended

### General
- [x] Develop, test and deploy smart contract
- [x] Develop front-end to interact with **Lancer Factory**, **Lancer Protocol** and deployed marketplaces
- [ ] Write end-to-end integration tests between front-end, backend and contracts
- [ ] Implement gasless meta-transactions for certain actions via relayers
- [ ] Write technical whitepaper explaining Lancer Protocol design & economics
- [ ] Apply to grants and accelerators
- [ ] Launch community documentation site on GitHub Pages
- [ ] Run security audit and formal verification on core contracts
- [ ] Deploy to mainnet (Ethereum / Base / Arbitrum) once fully audited
- [ ] Prepare v2 roadmap (potentially: governance, staking and multi-chain support)