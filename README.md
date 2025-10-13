TODO


## 🧱 Roadmap

### 🛠️ **Lancer Protocol**

- [ ] Set up project structure
- [ ] Develop Lancer Protocol's smart contracts 
- [ ] Implement milestones system for `deals`
- [ ] Define standard interfaces for third-party integrations  
- [ ] Build reusable libraries (`LancerTypes`, `LancerErrors`, `SafeTransferLib`) for shared logic 
- [ ] Develop Lancer Protocol's SDK 
- [ ] Develop Lancer Protocol's APIs
- [ ] Implement `DisputeManager` contract for handling disputes and emitting indexed events  
- [ ] Build `LancerHub` as the main protocol registry and router for modular extensions  
- [ ] Add `CrossChainExecutor` for cross-chain intent execution via **Avail Nexus SDK**  
- [ ] Create `LancerRegistry` to map users, escrows, and registered modules   
- [ ] Add optional modules such as `ReputationModule` and `ArbitrationModule` for extensibility  
- [ ] Write unit tests for escrow creation, release, and dispute lifecycle  
- [ ] Integrate **Envio HyperIndex** to index Escrow and Dispute events in real time  
- [ ] Document ABI interfaces and protocol workflows for developers  
- [ ] Implement an on-chain reputation scoring system based on transaction history and disputes  
- [ ] Add a module registration system for external developer contributions  
- [ ] Support multi-token escrows and wrapped asset payments  
- [ ] Integrate AI-assisted arbitration or dispute scoring  
- [ ] Demonstrate a cross-chain escrow flow between Ethereum and an Avail-supported network  
- [ ] Build analytics dashboards using **Envio HyperIndex** for usage metrics  
- [ ] Launch a developer documentation portal with examples and tutorials  
- [ ] Publish SDK or CLI tools for easy protocol integration  
- [ ] Produce demo video and documentation for ETHGlobal submission 
- [ ] Deploy **Lancer Protocol** contracts to testnet (e.g., Sepolia or Avail testnet)  
- [ ] Verify contracts on **Blockscout** or **Etherscan** for transparency  
- [ ] Set up **Envio indexing** service for production environment  
- [ ] Write and publish a detailed post-hackathon technical report and documentation 
---

### 🛒 **Lancer Market**

- [ ] Set up front-end scaffold to interact with `LancerHub` and `EscrowManager`  
- [ ] Implement basic job posting and hiring flow between buyers and freelancers  
- [ ] Integrate wallet connection (MetaMask or RainbowKit) with **PYUSD** payment support  
- [ ] Allow users to create and manage their on-chain escrows through the UI  
- [ ] Implement a simple dispute panel showing indexed disputes via **Envio HyperIndex**  
- [ ] Build a user dashboard to view active escrows, completed jobs, and earnings  
- [ ] Display cross-chain actions or settlements powered by **Avail Nexus SDK**  
- [ ] Add real-time event feedback for escrow creation, release, and dispute resolution  
- [ ] Write integration tests for front-end and contract interactions  
- [ ] Deploy **Lancer Market** as an example dApp consuming the protocol  
