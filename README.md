TODO

## Explorer
[Lancer Protocol Blockscout Explorer](https://lancer.cloud.blockscout.com/)

## 🧱 Roadmap

### 🛠️ **Lancer Protocol**

- [ ] Set up project structure
- [ ] Develop Lancer Protocol's smart contracts 
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
