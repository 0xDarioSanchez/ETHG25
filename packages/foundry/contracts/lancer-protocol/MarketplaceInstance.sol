//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.30;

// ====================================
//              IMPORTS          
// ====================================

import "forge-std/console.sol";

// ====================================
//             INTERFACE          
// ====================================

interface IPYUSD {
    function transferFrom(address from, address to, uint256 amount) external returns(bool);
    function transfer(address to, uint256 amount) external returns(bool);
}

interface IDisputeVoting {
    function createDispute(address requester, uint256 amount, string calldata reason) external;
}

// ====================================
//              CONTRACT          
// ====================================

/**
 * Smart contract with the main logic of Lancer Protocol
 * It also allows the owner to withdraw the Ether in the contract
 * @author 0xDarioSanchez
 */
contract MarketplaceInstance {

    // ====================================
    //          STATE VARIABLES          
    // ====================================

    address public owner;
    string public name;
    uint256 public feePercent;
    IPYUSD public pyusd;
    IDisputeVoting public disputeContract;

    mapping(address => uint256) public balances; // escrow balances
    mapping(uint256 => bool) public disputeResults;

    // ====================================
    //             MODIFIERS          
    // ====================================

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    // ====================================
    //              EVENTS          
    // ====================================

    event PaymentDeposited(address indexed user, uint256 amount);
    event DisputeRequested(uint256 indexed disputeId, address indexed requester);

    // ====================================
    //           CUSTOM ERRORs          
    // ====================================

    // ====================================
    //           CONSTRUCTOR          
    // ====================================

    constructor(
        address _owner, 
        string memory _name, 
        uint256 _feePercent, 
        address _pyusd
    ) {
        owner = _owner;
        name = _name;
        feePercent = _feePercent;
        pyusd = IPYUSD(_pyusd);
    }

    // ====================================
    //         EXTERNAL FUNCTIONS          
    // ====================================

    function setDisputeContract(address _dispute) external {
        require(address(disputeContract) == address(0), "Already set");
        disputeContract = IDisputeVoting(_dispute);
    }

    // Deposit funds to escrow
    function deposit(uint256 amount) external {
        require(pyusd.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        balances[msg.sender] += amount;
        emit PaymentDeposited(msg.sender, amount);
    }

    // Request a dispute, transfer dispute fee to Voting contract
    function requestDispute(string calldata reason) external {
        uint256 disputeFee = 20 * 10**18; // 20 PYUSD, assuming 18 decimals
        require(balances[msg.sender] >= disputeFee, "Insufficient balance for dispute");

        // Deduct dispute fee from user escrow
        balances[msg.sender] -= disputeFee;
        require(pyusd.transfer(address(disputeContract), disputeFee), "Dispute transfer failed");

        // Notify Voting contract
        disputeContract.createDispute(msg.sender, disputeFee, reason);
        emit DisputeRequested(0, msg.sender); // disputeId will be generated in Voting contract
    }

    // Apply dispute result: adjust balances based on outcome (optional)
    function applyDisputeResult(uint256 disputeId, address[] calldata judges, uint256 totalReward) external {
        require(msg.sender == address(disputeContract), "Unauthorized");
        // Distribute rewards if needed, example:
        for(uint i=0; i<judges.length; i++){
            pyusd.transfer(judges[i], totalReward / judges.length);
        }
        // 2 PYUSD stays in Voting contract, handled internally there
        disputeResults[disputeId] = true;
    }

    // ====================================
    //          PUBLIC FUNCTIONS          
    // ====================================


    // ====================================
    //        PURE & VIEW FUNCTIONS          
    // ====================================

    // ====================================
    //              OTHERS          
    // ====================================

    //TODO function to give the locked funds to a lending protocol
    
    //Function that allows the contract to receive ETH
    receive() external payable { }

}
