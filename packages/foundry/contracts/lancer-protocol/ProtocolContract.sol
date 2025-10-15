//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.30;

// ====================================
//              IMPORTS          
// ====================================

import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./interfaces/IPYUSD.sol";
import "./interfaces/IProtocolContract.sol";
import "./interfaces/IFactory.sol";

// ====================================
//              CONTRACT          
// ====================================

/**
 * Smart contract with the main logic of Lancer Protocol
 * It also allows the owner to withdraw the Ether in the contract
 * @author 0xDarioSanchez
 */
contract ProtocolContract {
    using SafeERC20 for IERC20;

    // ====================================
    //          STATE VARIABLES          
    // ====================================

    address public owner;
    IPYUSD public pyusd;
    address public factory;

    uint256 public keepAmount = 2 * 10**18; // 2 PYUSD kept in contract
    uint64 public disputeCount;

    struct Judge {
        address judgeAddress;
        uint256 reputation;
    }

    struct Dispute {
        uint32 disputeId;           //ID to connect the dispute with the corresponding deal
        address contractAddress;    //Address of the contract from where the dispute was opened
        address requester;          //The one who opens the dispute. It will always be the payer
        address beneficiary;        //The one who is disputed against.
        string requesterProofs;     //Proofs provided by the requester
        string beneficiaryProofs;   //Proofs provided by the beneficiary
        bool waitingForJudges;      //True if waiting for the judges to be assigned
        bool isOpen;                //True if the dispute is open to vote, False if it is closed
        uint256 votesFor;           //Votes in favor of the requester
        uint256 votesAgainst;       //Votes against the requester
        bool resolved;              //True if the dispute has been resolved
        address[] voters;           //List of judges that voted in the dispute
        bool[] votes;             //List of votes corresponding to the judges in the voters array
    }

    mapping(address => Judge) public judges;
    mapping(uint64 => Dispute) public disputes;


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

    event JudgeRegistered(address indexed judge);
    event DisputeCreated(uint256 indexed disputeId, address indexed requester, address indexed contractAddress);
    event DisputeResolved(uint256 indexed disputeId, address winner);

    // ====================================
    //           CUSTOM ERRORs          
    // ====================================

    // ====================================
    //           CONSTRUCTOR          
    // ====================================

    constructor(address _owner, address _pyusd, address _factory) {
        owner = _owner;
        pyusd = IPYUSD(_pyusd);
        factory = _factory;
    }

    // ====================================
    //         EXTERNAL FUNCTIONS          
    // ====================================

    function registerAsJudge() external {
        //require(judges[msg.sender] == Judge(address(0), 0), "Already registered");
        emit JudgeRegistered(msg.sender);
    }

    //TODO it must be ensured that only the Marketplace contract can call this function
    function createDispute(address _requester, string calldata _proofs) external {
        require(IFactory(factory).isDeployedMarketplace(msg.sender), "Unauthorized");

        Dispute storage dispute = disputes[disputeCount];

        dispute.requester = _requester;
        dispute.requesterProofs = _proofs;
        emit DisputeCreated(disputeCount, _requester, msg.sender);

        disputeCount++;
    }

    function updateDisputeForPayer(uint64 _disputeId, address _requester, string calldata _proof) external {
        Dispute storage dispute = disputes[_disputeId];
        require(dispute.requester == _requester, "Not the requester");
        dispute.requesterProofs = string(abi.encodePacked(dispute.requesterProofs, " | ", _proof));
    }

    function updateDisputeForBeneficiary(uint64 _disputeId, address _beneficiary, string calldata _proof) external {
        Dispute storage dispute = disputes[_disputeId];
        require(dispute.beneficiary == _beneficiary, "Not the beneficiary");
        dispute.beneficiaryProofs = string(abi.encodePacked(dispute.beneficiaryProofs, " | ", _proof));
    }

    function vote(uint64 _disputeId, bool _support) external {
        Dispute storage dispute = disputes[_disputeId];
        Judge storage j = judges[msg.sender];
        require(judges[msg.sender].judgeAddress != address(0), "Not a judge");
        // require(!d.voted[msg.sender], "Already voted");

        if(_support){
            dispute.votesFor += j.reputation;
        } else {
            dispute.votesAgainst += j.reputation;
        }
        // dispute.voted[msg.sender] = true;
    }

    // function resolveDispute(uint256 disputeId) external {
    //     Dispute storage d = disputes[disputeId];
    //     require(!d.resolved, "Already resolved");

    //     bool outcomeForRequester = d.votesFor > d.votesAgainst;
    //     d.resolved = true;

    //     // distribute remaining PYUSD (after keeping 2) to judges that voted for winner
    //     uint256 rewardPool = d.amount - keepAmount;
    //     address[] memory winners;

    //     // determine winners
    //     for(uint i=0; i<disputes[disputeId].votedForWinner.length; i++){
    //         winners[i] = disputes[disputeId].votedForWinner[i];
    //     }

    //     if(winners.length > 0){
    //         uint256 rewardPerJudge = rewardPool / winners.length;
    //         for(uint i=0; i<winners.length; i++){
    //             pyusd.safeTransfer(winners[i], rewardPerJudge);
    //         }
    //     }

    //     emit DisputeResolved(disputeId, outcomeForRequester ? d.requester : address(0));
    // }

    // ====================================
    //          PUBLIC FUNCTIONS          
    // ====================================

    /**
     * Function that allows the owner to withdraw all the Ether in the contract
     * The function can only be called by the owner of the contract as defined by the isOwner modifier
     */
    function withdraw() public onlyOwner {
        (bool success,) = owner.call{ value: address(this).balance }("");
        require(success, "Failed to send Ether");
    }

    // ====================================
    //        PURE & VIEW FUNCTIONS          
    // ====================================

    // ====================================
    //              OTHERS          
    // ====================================

    //Function that allows the contract to receive ETH
    receive() external payable { }

}