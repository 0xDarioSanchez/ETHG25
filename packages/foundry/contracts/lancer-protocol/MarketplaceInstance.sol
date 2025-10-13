//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.30;

// ====================================
//              IMPORTS          
// ====================================

import "forge-std/console.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IPYUSD.sol";
import "./interfaces/IProtocolContract.sol";

// ====================================
//              CONTRACT          
// ====================================

/**
 * Instance of contracts deployed by Lancer Protocol
 * It allows the Owner to withdraw the PYUSD earned throught lending
 * @author 0xDarioSanchez
 */
contract MarketplaceInstance {

    // ====================================
    //          STATE VARIABLES          
    // ====================================

    address public immutable owner;             //Owner of the contract, the one who deployed it
    address public immutable token;             //PYUSD token address
    //address public immutable token;             //PYUSD token address
    uint256 public feePercent;                  //Fee percentage charged on each deal, in PYUSD
    IPYUSD public pyusd;                        //Interface for PYUSD token
    IProtocolContract public protocolContract;  //Interface for Protocol contract

    mapping(address => uint256) public balances;    // User's balances
    mapping(uint256 => bool) public disputeResults; //TODO is necessary?

    //Struct for storing user information
    //The reason to have 3 booleans is to allow users to be in different roles while using the same address
    struct User {
        address userAddress;
        uint256 balance;        //Balance in PYUSD disponible to withdraw
        int8 reputationAsUser;  //Reputation calculated from deals as payer or beneficiary
        int8 reputationAsJudge; //Reputation calculated from voting process as judge
        bool isPayer;           //Determines if the user can act as a payer
        bool isBeneficiary;     //Determines if the user can act as a beneficiary
        bool isJudge;           //Determines if the user can act as a judge
        uint32[] deals;         // deals where the user is involved
    }

    struct Deal {
        uint32 dealId;          //ID to identify the deal
        address payer;          //The one who pays, it can be a company or a buyer
        address beneficiary;    //The one who receives the payment, it can be a freelancer or a seller
        uint256 amount;         //Amount in PYUSD
        uint256 fee;            //Fee in PYUSD
        uint256 startedAt;      //Timestamp when the deal was accepted
        bool accepted;            //True if the deal is open, false if it is closed
        bool disputed;          //True if there is an open dispute for this deal
    }

    struct Dispute {
        uint32 dealId;          //ID to connect the dispute with the corresponding deal
        address requester;      //The one who opens the dispute
        string reason;          //Reason for opening the dispute
        bool isOpen;            //True if the dispute is open, false if it is closed
    }   

    User[] public users;        //Array of all users
    Deal[] public deals;        //Array of all deals
    Dispute[] public disputes;  //Array of all disputes

    // ====================================
    //             MODIFIERS          
    // ====================================

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    modifier onlyReceiver(uint256 dealId) {
        require(msg.sender == deals[dealId].beneficiary, "Only receiver can perform this action");
        _;
    }

    modifier escrowExists(uint256 dealId) {
        require(deals[dealId].amount > 0, "Deal does not exist");
        _;
    }

    modifier notReleased(uint256 dealId) {
        require(!deals[dealId].accepted, "Deal already released");
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
        uint256 _feePercent, 
        address _token
    ) {
        owner = _owner;
        feePercent = _feePercent;
        pyusd = IPYUSD(_token);
    }

    // ====================================
    //         EXTERNAL FUNCTIONS          
    // ====================================

    function setDisputeContract(address _dispute) external {
        require(address(protocolContract) == address(0), "Already set");
        protocolContract = IProtocolContract(_dispute);
    }

    // Deposit funds to deal
    function deposit(uint256 amount) external {
        require(pyusd.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        balances[msg.sender] += amount;
        emit PaymentDeposited(msg.sender, amount);
    }

    // Request a dispute, transfer dispute fee to Voting contract
    function requestDispute(string calldata reason) external {
        uint256 disputeFee = 20 * 10**18; // 20 PYUSD, assuming 18 decimals
        require(balances[msg.sender] >= disputeFee, "Insufficient balance for dispute");

        // Deduct dispute fee from user deal
        balances[msg.sender] -= disputeFee;
        require(pyusd.transfer(address(protocolContract), disputeFee), "Dispute transfer failed");

        // Notify Voting contract
        protocolContract.createDispute(msg.sender, disputeFee, reason);
        emit DisputeRequested(0, msg.sender); // disputeId will be generated in Voting contract
    }

    // Apply dispute result: adjust balances based on outcome (optional)
    function applyDisputeResult(uint256 disputeId, address[] calldata judges, uint256 totalReward) external {
        require(msg.sender == address(protocolContract), "Unauthorized");
        // Distribute rewards if needed, example:
        for(uint i=0; i<judges.length; i++){
            pyusd.transfer(judges[i], totalReward / judges.length);
        }
        // 2 PYUSD stays in Voting contract, handled internally there
        disputeResults[disputeId] = true;
    }


    function createDeal(address receiver, uint256 amount, uint32 dealId) external payable {
        require(deals[dealId].amount == 0, "Deal already exists");
        require(amount > 0, "Amount must be greater than zero");
        require(receiver != address(0), "Invalid receiver address");

        deals[dealId] = Deal({
            dealId: dealId,
            payer: msg.sender,
            beneficiary: receiver,
            amount: amount,
            fee: (amount * feePercent) / 100,
            startedAt: 0,
            accepted: false,
            disputed: false
        });

        //emit EscrowCreated(escrowId, msg.sender, receiver, amount);
    }

    function acceptDeal(uint32 dealId) external escrowExists(dealId) notReleased(dealId) {
        Deal storage deal = deals[dealId];
        require(msg.sender == deals[dealId].payer, "Only payer can perform this action");

        deal.accepted = true;
        deal.startedAt = block.timestamp;

        IERC20(token).transfer(deal.beneficiary, deal.amount); 

        //emit EscrowReleased(escrowId);
    }

    function cancelDeal(uint32 dealId) external escrowExists(dealId) notReleased(dealId) {
        Deal storage deal = deals[dealId];
        require(msg.sender == deals[dealId].payer, "Only payer can perform this action");

        deal.accepted = false;
        delete deals[dealId];

        //emit EscrowCancelled(escrowId);
    }  

    // ====================================
    //          PUBLIC FUNCTIONS          
    // ====================================


    // ====================================
    //        PURE & VIEW FUNCTIONS          
    // ====================================

    function getContractAddress() external view returns (address) {
        return address(this);
    }



    // ====================================
    //              OTHERS          
    // ====================================

    //TODO function to give the locked funds to a lending protocol
    
    //Function that allows the contract to receive ETH
    receive() external payable { }

}
