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

Escrow Creation
A buyer or dApp creates an escrow via EscrowManager, specifying a seller and amount in **PYUSD**.
Funds are locked securely in the contract until release or dispute.

Safe Payments
Payments remain in escrow until both sides approve, ensuring fairness.
Developers can build custom logic around deadlines, milestones, or deliverables.

Dispute Handling
If a disagreement occurs, users can trigger a dispute through DisputeManager.
The protocol emits verifiable events, which can be indexed via Envio HyperIndex or settled cross-chain with Avail.

Smart Contract Transparency (**Blockscout**)
Lancer integrates Blockscout for allowing anyone to explore contract code, transactions, and interactions directly from the Lancer frontend.

Data Indexing (**Envio**)
All on-chain events are indexed in real-time using Envio HyperIndex, allowing instant access to user escrows, dispute status, and analytics dashboards.



## Setup

### Requirements

You need to install the following tools:

- [Node (>= v20.18.3)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))

### Quickstart

To get started with Scaffold-ETH 2, follow the steps below:

1. Install dependencies if it was skipped in CLI:

```
cd my-dapp-example
yarn install
```

2. Run a local network in the first terminal:

```
yarn chain
```

This command starts a local Ethereum network using Foundry. The network runs on your local machine and can be used for testing and development. You can customize the network configuration in `packages/foundry/foundry.toml`.

3. On a second terminal, deploy the test contract:

```
yarn deploy
```

This command deploys a test smart contract to the local network. The contract is located in `packages/foundry/contracts` and can be modified to suit your needs. The `yarn deploy` command uses the deploy script located in `packages/foundry/script` to deploy the contract to the network. You can also customize the deploy script.

4. On a third terminal, start your NextJS app:

```
yarn start
```

Visit your app on: `http://localhost:3000`. You can interact with your smart contract using the `Debug Contracts` page. You can tweak the app config in `packages/nextjs/scaffold.config.ts`.

Run smart contract test with `yarn foundry:test`

- Edit your smart contracts in `packages/foundry/contracts`
- Edit your frontend homepage at `packages/nextjs/app/page.tsx`. For guidance on [routing](https://nextjs.org/docs/app/building-your-application/routing/defining-routes) and configuring [pages/layouts](https://nextjs.org/docs/app/building-your-application/routing/pages-and-layouts) checkout the Next.js documentation.
- Edit your deployment scripts in `packages/foundry/script`



## 🧱 Roadmap

### 🛠️ **Lancer Protocol**

- [x] Set up project structure
- [x] Develop Lancer Protocol's smart contracts 
- [ ] Implement milestones system for `deals`
- [ ] Define standard interfaces for third-party integrations  
- [ ] Build reusable libraries (`LancerTypes`, `LancerErrors`, `SafeTransferLib`) for shared logic 
- [ ] Implement `ProtocolContract` contract for handling disputes and emitting indexed events  
- [ ] Implement an on-chain reputation scoring system based on previous disputes results
- [ ] Implement a tier system for judges, based on reputation
- [ ] Write unit and integrations tests for all the contracts
- [ ] Deploy **Lancer Protocol** contracts to testnet (e.g., Sepolia or Avail testnet)  
- [ ] Verify contracts on **Blockscout** or **Etherscan** for transparency  
- [ ] Develop Lancer Protocol's SDK and APIs
- [ ] Add `CrossChainExecutor` for cross-chain intent execution via **Avail Nexus SDK**  
- [ ] Integrate **Envio HyperIndex** to index Escrow and Dispute events in real time  
- [ ] Document ABI interfaces and protocol workflows for developers  
- [ ] Add a module registration system for external developer contributions  
- [ ] Demonstrate a cross-chain escrow flow between Ethereum and an Avail-supported network  
- [ ] Build analytics dashboards using **Envio HyperIndex** for usage metrics  
- [ ] Launch a developer documentation portal with examples and tutorials  
- [ ] Publish SDK or CLI tools for easy protocol integration  
- [ ] Set up **Envio indexing** service for production environment  
- [ ] In `ProtocolContract` implement a random selection of the judges for the specific dispute
- [ ] In `ProtocolContract` implement a private voting system to only show the votes after the votation is concluded

### 🛒 **Lancer Market**

- [ ] Deploy **Lancer Market** as an example dApp consuming the protocol  
- [ ] Set up front-end scaffold to interact with `LancerHub` and `EscrowManager`  
- [ ] Implement basic job posting and hiring flow between buyers and freelancers  
- [ ] Integrate wallet connection (MetaMask or RainbowKit) with **PYUSD** payment support  
- [ ] Allow users to create and manage their on-chain escrows through the UI  
- [ ] Implement a simple dispute panel showing indexed disputes via **Envio HyperIndex**  
- [ ] Build a user dashboard to view active escrows, completed jobs, and earnings  
- [ ] Display cross-chain actions or settlements powered by **Avail Nexus SDK**  
- [ ] Add real-time event feedback for escrow creation, release, and dispute resolution  
- [ ] Write integration tests for front-end and contract interactions  
