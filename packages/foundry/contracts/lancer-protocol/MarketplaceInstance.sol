//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.30;

// ====================================
//              IMPORTS          
// ====================================

import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

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
    using SafeERC20 for IERC20;
    // ====================================
    //          STATE VARIABLES          
    // ====================================

    address public immutable owner;             //Owner of the contract, the one who deployed it
    address public immutable token;             //PYUSD token address
    uint256 public feePercent;                  //Fee percentage charged on each deal, in PYUSD
    address public immutable protocolAddress;   //Address of the Protocol contract
    IERC20 public pyusd;                        //Interface for PYUSD token
    IProtocolContract public protocolContract;  //Interface for Protocol contract
    uint64 public dealIdCounter;                //Incremental ID for deals

    //Struct for storing user information
    //The reason to have 3 booleans is to allow users to be in different roles while using the same address
    struct User {
        address userAddress;
        uint256 balance;        //Balance in PYUSD disponible to withdraw
        int8 reputationAsUser;  //Reputation calculated from deals as payer or beneficiary
        int8 reputationAsJudge; //Reputation calculated from voting process as judge
        bool isPayer;           //Determines if the user can act as a payer (e.g. freelancer or seller)
        bool isBeneficiary;     //Determines if the user can act as a beneficiary (e.g. company or buyer)
        bool isJudge;           //Determines if the user can act as a judge
        uint64[] deals;         // deals where the user is involved
    }

    //Struct to store deal information
    //`amount` indicates the total
    //TODO add milestones system
    struct Deal {
        uint64 dealId;          //ID to identify the deal
        address payer;          //The one who pays, it can be a company or a buyer
        address beneficiary;    //The one who receives the payment, it can be a freelancer or a seller
        uint256 amount;         //Amount in PYUSD
        uint256 startedAt;      //Timestamp when the deal was accepted
        uint16 duration;        //Duration in days for the deal
        bool accepted;          //True if the deal is open, false if it is closed
        bool disputed;          //True if there is an open dispute for this deal
    }

    struct Dispute {
        uint32 dealId;              //ID to connect the dispute with the corresponding deal
        address requester;          //The one who opens the dispute. It will always be the payer
        string requesterProofs;     //Proofs provided by the requester
        string beneficiaryProofs;   //Proofs provided by the beneficiary
        bool[] votes;               //Array of votes, true for requester, false for beneficiary
        bool waitingForJudges;      //True if waiting for the judges to be assigned
        bool isOpen;                //True if the dispute is open to vote, False if it is closed
    }   

    mapping(address => User) public users;      //Mapping to store users information
    mapping(uint256 => Deal) public deals;      //Mapping to store deals information
    mapping(uint64 => Dispute) public disputes; //Mapping to store disputes information

    // ====================================
    //             MODIFIERS          
    // ====================================

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    modifier onlyUser() {
        require(users[msg.sender].userAddress == msg.sender, "Not the user");
        _;
    }

    modifier onlyBeneficiary(uint64 dealId) {
        require(msg.sender == deals[dealId].beneficiary, "Only receiver can perform this action");
        _;
    }

    modifier onlyPayer(uint64 dealId) {
        require(msg.sender == deals[dealId].payer, "Only payer can perform this action");
        _;
    }

    modifier dealExists(uint64 dealId) {
        require(deals[dealId].amount > 0, "Deal does not exist");
        _;
    }

    // modifier notAccepted(uint64 dealId) {
    //     require(!deals[dealId].accepted, "Deal not accepted");
    //     _;
    // }

    // ====================================
    //              EVENTS          
    // ====================================

    event UserRegistered(address indexed user, bool isPayer, bool isBeneficiary, bool isJudge);
    event DealCreated(uint64 indexed dealId, address indexed payer, address indexed beneficiary, uint256 amount);
    event DealAccepted(uint64 indexed dealId);
    event DealRejected(uint64 indexed dealId);
    event DisputeRequested(uint256 indexed disputeId, address indexed requester);
    event UserWithdrew(address indexed user, uint256 amount);
    event PaymentDeposited(address indexed user, uint256 amount);
    event DealAmountUpdated(uint64 indexed dealId, uint256 newAmount);
    event DealFinalized(uint64 indexed dealId);
    event DealDurationUpdated(uint64 indexed dealId, uint16 newDuration);
    event DisputeCreated(uint64 indexed dealId, address indexed requester);

    // ====================================
    //           CUSTOM ERRORs          
    // ====================================

    // ====================================
    //           CONSTRUCTOR          
    // ====================================

    constructor(
        address _owner, 
        uint256 _feePercent, 
        address _token,
        address _protocolAddress
    ) {
        owner = _owner;
        feePercent = _feePercent;
        pyusd = IERC20(_token);
        protocolAddress = _protocolAddress;
    }

    // ====================================
    //         EXTERNAL FUNCTIONS          
    // ====================================

    function registerUser(bool _isPayer, bool _isBeneficiary, bool _isJudge) external {
        //Check if the user is already registered
        require(users[msg.sender].userAddress == address(0), "User already registered");
        require(_isPayer || _isBeneficiary || _isJudge, "At least one role must be true");

        //Register the user
        users[msg.sender] = User({
            userAddress: msg.sender,
            balance: 0,
            reputationAsUser: 0,
            reputationAsJudge: 0,
            isPayer: _isPayer,
            isBeneficiary: _isBeneficiary,
            isJudge: _isJudge,
            deals: new uint64[](0)
        });

        emit UserRegistered(msg.sender, _isPayer, _isBeneficiary, _isJudge);
    }

    function addRole(bool _isPayer, bool _isBeneficiary, bool _isJudge) external onlyUser {
        require(_isPayer || _isBeneficiary || _isJudge, "At least one role must be true");

        if(_isPayer){
            users[msg.sender].isPayer = true;
        }
        if(_isBeneficiary){
            users[msg.sender].isBeneficiary = true;
        }
        if(_isJudge){
            users[msg.sender].isJudge = true;
        }

        emit UserRegistered(msg.sender, _isPayer, _isBeneficiary, _isJudge);
    }


    //Allow users registered as beneficiaries to create deals
    //It must be accepted by the payer to be effective
    //Only `amount` can be updated after creation, but not if already accepted
    function createDeal(address _receiver, uint256 _amount, uint16 _duration) external {
        require(_amount > 0, "Amount must be greater than zero");
        require(_receiver != address(0), "Invalid receiver address");
        require(users[msg.sender].isBeneficiary, "User not registered as beneficiary");

        deals[dealIdCounter] = Deal({
            dealId: dealIdCounter,
            beneficiary: msg.sender,
            payer: _receiver,
            amount: _amount,
            duration: _duration,
            startedAt: 0,
            accepted: false,
            disputed: false
        });

        emit DealCreated(dealIdCounter, msg.sender, _receiver, _amount);

        dealIdCounter += 1;
    }


    function updateDealAmount(uint64 _dealId, uint256 newAmount) external dealExists(_dealId) {
        Deal storage deal = deals[_dealId];

        require(msg.sender == deal.payer, "Only payer can update the deal");
        require(!deal.accepted, "Deal already accepted");
        require(newAmount > 0, "Amount must be greater than zero");

        deal.amount = newAmount;

        emit DealAmountUpdated(_dealId, newAmount);
    }

    //Function to update the duration of a deal, only if not accepted yet
    //Duration is in days
    function updateDealDuration(uint64 _dealId, uint16 newDuration) external dealExists(_dealId) {
        Deal storage deal = deals[_dealId];

        require(msg.sender == deal.payer, "Only payer can update the deal");
        require(!deal.accepted, "Deal already accepted");
        require(newDuration > 0, "Duration must be greater than zero");

        deal.amount = newDuration;

        emit DealDurationUpdated(_dealId, newDuration);
    }


    //Function to accept a deal, transferring the funds to the contract
    //`Payer` transfer tokens to the contract but its balance is not updated until, that only happens if `Payer` request for a dispute and win it
    function acceptDeal(uint32 _dealId) external dealExists(_dealId) {
        Deal storage deal = deals[_dealId];
        require(msg.sender == deals[_dealId].payer, "Only payer can perform this action");

        deal.accepted = true;
        deal.startedAt = block.timestamp;

        IERC20(token).safeTransfer(address(this), deal.amount);

        emit DealAccepted(_dealId);
    }

    //If `Payer` does not agree with the deal, it can reject it
    //The deal is deleted
    function rejectDeal(uint64 _dealId) external dealExists(_dealId) {
        Deal storage deal = deals[_dealId];

        require(msg.sender == deal.payer, "Only payer can reject the deal");
        require(!deal.accepted, "Deal already accepted");

        delete deals[_dealId];

        emit DealRejected(_dealId);
    } 


    //Function to finalize a deal once `Payer` is satisfied with the conditions
    //`Beneficiary` balance is updated to allow its withdrawal
    //The corresponding fee is kept in the contract to be withdrawn by the owner
    //The deal is deleted
    function finishDeal(uint64 _dealId) external onlyPayer(_dealId) dealExists(_dealId) {
        Deal memory deal = deals[_dealId];

        require(deal.accepted, "Deal not accepted");
        require(!deal.disputed, "Deal is disputed");

        //Calculate fee
        uint256 fee = (deal.amount * feePercent) / 100;

        //Update beneficiary balance
        users[deal.beneficiary].balance += (deal.amount - fee);

        delete deals[_dealId];

        emit DealFinalized(_dealId);
    }


    //Function to request the payment of a deal after its duration has passed
    //Only can be executed by the `Beneficiary` if 1 week have passed since the deal duration ended
    //`Beneficiary` balance is updated to allow its withdrawal
    //The corresponding fee is kept in the contract to be withdrawn by the owner
    //The deal is deleted
    function requestDealPayment(uint64 _dealId) external onlyBeneficiary(_dealId) dealExists(_dealId) {
        Deal memory deal = deals[_dealId];

        require(deal.accepted, "Deal not accepted");
        require(!deal.disputed, "Deal is disputed");
        require(block.timestamp >= deal.startedAt + (deal.duration * 1 days) + 1 weeks, "Deal duration not sufficient");

        //Calculate fee
        uint256 fee = (deal.amount * feePercent) / 100;

        //Update beneficiary balance
        users[deal.beneficiary].balance += (deal.amount - fee);

        delete deals[_dealId];

        emit DealFinalized(_dealId);
    }


    // Request a dispute, transfer dispute fee to Voting contract
    function requestDispute(uint64 _dealId, string calldata _proof) external dealExists(_dealId) onlyPayer(_dealId) {
        pyusd.safeTransferFrom(msg.sender, protocolAddress, 20 * 10**18); // 20 PYUSD, assuming 18 decimals
        //TODO check amount of decimals for PYUSD
        Deal storage deal = deals[_dealId];
        require(deal.accepted, "Deal not accepted");
        require(!deal.disputed, "Deal already disputed");

        deal.disputed = true;

        // Notify Protocol contract
        protocolContract.createDispute(msg.sender, _dealId, _proof);

        emit DisputeCreated(_dealId, msg.sender);

    }    
    //     uint256 disputeFee = 20 * 10**18; // 20 PYUSD, assuming 18 decimals
    //     require(balances[msg.sender] >= disputeFee, "Insufficient balance for dispute");

    //     // Deduct dispute fee from user deal
    //     balances[msg.sender] -= disputeFee;
    //     require(pyusd.transfer(address(protocolContract), disputeFee), "Dispute transfer failed");

    //     // Notify Voting contract
    //     protocolContract.createDispute(msg.sender, disputeFee, reason);
    //     emit DisputeRequested(0, msg.sender); // disputeId will be generated in Voting contract
    // }

    // // Apply dispute result: adjust balances based on outcome (optional)
    // function applyDisputeResult(uint256 disputeId, address[] calldata judges, uint256 totalReward) external {
    //     require(msg.sender == address(protocolContract), "Unauthorized");
    //     // Distribute rewards if needed, example:
    //     for(uint i=0; i<judges.length; i++){
    //         pyusd.transfer(judges[i], totalReward / judges.length);
    //     }
    //     // 2 PYUSD stays in Voting contract, handled internally there
    //     disputeResults[disputeId] = true;
    // }


    function withdraw(uint256 _amount) external onlyUser {
        require(users[msg.sender].balance >= _amount, "Insufficient balance");

        users[msg.sender].balance -= _amount;
        pyusd.safeTransfer(msg.sender, _amount);

        emit UserWithdrew(msg.sender, _amount);
    }



    // ====================================
    //          PUBLIC FUNCTIONS          
    // ====================================

    // ====================================
    //         INTERNAL FUNCTIONS          
    // ====================================

    // function setDisputeContract(address _dispute) internal {
    //     require(address(protocolContract) == address(0), "Already set");
    //     protocolContract = IProtocolContract(_dispute);
    // }

    // ====================================
    //          PRIVATE FUNCTIONS          
    // ====================================

    // Deposit funds to deal
    function deposit(uint256 _amount) private {
        require(pyusd.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        users[msg.sender].balance += _amount;

        emit PaymentDeposited(msg.sender, _amount);
    }

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
