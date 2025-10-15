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
    uint8 public numberOfVotes = 5; // Number of votes required to resolve a dispute

    struct Judge {
        address judgeAddress;
        int8 reputation;
    }

    struct Dispute {
        uint32 disputeId;           //ID to connect the dispute with the corresponding deal
        address contractAddress;    //Address of the contract from where the dispute was opened
        address requester;          //The one who opens the dispute. It will always be the payer
        address beneficiary;        //The one who is disputed against.
        string requesterProofs;     //Proofs provided by the requester
        string beneficiaryProofs;   //Proofs provided by the beneficiary
        address[] ableToVote;       //List of judges that can vote in the dispute
        address[] voters;           //List of judges that already voted in the dispute
        bool[] votes;               //List of votes corresponding to the judges in the voters array, it seems redundant but it is to easily assign tokens and reputation
        uint8 votesFor;             //Votes in favor of the requester
        uint8 votesAgainst;         //Votes against the requester
        bool waitingForJudges;      //True if waiting for the judges to be assigned
        bool isOpen;                //True if the dispute is open to vote, False if it is closed
        bool resolved;              //True if the dispute has been resolved
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

    constructor(address _owner, address _pyusd) {
        owner = _owner;
        pyusd = IPYUSD(_pyusd);
    }

    // ====================================
    //         EXTERNAL FUNCTIONS          
    // ====================================

    /// Set the Factory contract address, can only be called once and only by the owner
    /// @param _factory is the address of the Factory contract
    function setFactoryAddress(address _factory) external onlyOwner {
        require(factory == address(0), "Factory already set");
        require(_factory != address(0), "Invalid address");
        factory = _factory;
    }

    /// Function to register as a judge
    /// Anyone can register as a judge, starting with 0 reputation
    function registerAsJudge() external {
        require(judges[msg.sender].judgeAddress == address(0), "Already registered");
        judges[msg.sender] = Judge(msg.sender, 0);

        emit JudgeRegistered(msg.sender);
    }


    /// Function called by a MarketplaceInstance contract to create a dispute
    /// @param _requester address of the requester (the one who opens the dispute, it will always be the `payer`)
    /// @param _proofs striing to indicate a link to the proofs provided by the requester, it can be updated later
    function createDispute(address _requester, string calldata _proofs) external {
        require(IFactory(factory).isDeployedMarketplace(msg.sender), "Unauthorized");

        Dispute storage dispute = disputes[disputeCount];

        dispute.requester = _requester;
        dispute.requesterProofs = _proofs;
        dispute.contractAddress = msg.sender;

        emit DisputeCreated(disputeCount, _requester, msg.sender);

        disputeCount++;
    }


    function updateDisputeForPayer(uint64 _disputeId, address _requester, string calldata _proof) external {
        Dispute storage dispute = disputes[_disputeId];
        require(dispute.requester == _requester, "Not the requester");
        require(bytes(_proof).length > 0, "Proof cannot be empty");
        require(!dispute.resolved, "Dispute resolved");

        dispute.requesterProofs = _proof;
    }


    function updateDisputeForBeneficiary(uint64 _disputeId, address _beneficiary, string calldata _proof) external {
        Dispute storage dispute = disputes[_disputeId];
        require(dispute.beneficiary == _beneficiary, "Not the beneficiary");
        require(bytes(_proof).length > 0, "Proof cannot be empty");
        require(!dispute.resolved, "Dispute resolved");

        dispute.beneficiaryProofs = _proof;
    }


    function registerToVote(uint64 _disputeId) external {
        Dispute storage dispute = disputes[_disputeId];
        require(judges[msg.sender].judgeAddress != address(0), "Not a judge");

        // If a judge vote as the minority, they lose 1 reputation point
        // In the future, I want to add function to rest for example 3 points if the judge doesn't vote
        require(judges[msg.sender].reputation >= -3, "Not enough reputation");

        require(dispute.waitingForJudges, "Judges already assigned");

        // Check if the judge is already registered to vote
        for (uint256 i = 0; i < dispute.ableToVote.length; i++) {
            require(dispute.ableToVote[i] != msg.sender, "Judge already registered");
        }

        dispute.ableToVote.push(msg.sender);

        // If the required number of judges is reached, the dispute is open for voting
        if (dispute.ableToVote.length == numberOfVotes) {
            dispute.waitingForJudges = false;
            dispute.isOpen = true;
        }
    }

    /// Function to vote in a dispute, only judges assigned to the dispute can vote
    /// @param _disputeId Indicate the corresponding dispute
    /// @param _support boolean that indicates if the judge supports the requester (true) or the beneficiary (false)
    function vote(uint64 _disputeId, bool _support) external {
        Dispute storage dispute = disputes[_disputeId];
        require(_checkIfAbleToVote(disputes[_disputeId], msg.sender), "Judge not allowed to vote");
        require(!dispute.resolved, "Dispute already resolved");
        require(dispute.isOpen, "Dispute not open");

        // Check if the judge has already voted
        for (uint256 i = 0; i < dispute.voters.length; i++) {
            require(dispute.voters[i] != msg.sender, "Judge already voted");
        }
        dispute.voters.push(msg.sender);
        dispute.votes.push(_support);

        if (_support) {
            dispute.votesFor++;
        } else {
            dispute.votesAgainst++;
        }

        if (dispute.voters.length == numberOfVotes) {
            dispute.isOpen = false;
            dispute.resolved = true;
        }
    }


    /// To update the number of votes required to resolve a dispute, in the future I want to manage different levels of disputes, allowing to pay more to have more judges voting
    /// @param _newNumber new number of votes required
    function updateNumberOfVotes(uint8 _newNumber) external onlyOwner {
        require(_newNumber > 0, "Must be greater than 0");
        numberOfVotes = _newNumber;
    }


    // ====================================
    //          PUBLIC FUNCTIONS          
    // ====================================

    /**
     * Function that allows the owner to withdraw all the Ether in the contract
     * The function can only be called by the owner of the contract as defined by the onlyOwner modifier
     */
    function withdraw() public onlyOwner {
        (bool success,) = owner.call{ value: address(this).balance }("");
        require(success, "Failed to send Ether");
    }

    // ====================================
    //        PURE & VIEW FUNCTIONS          
    // ====================================


    function _checkIfAbleToVote(Dispute memory dispute, address judge) internal pure returns (bool) {
        for (uint256 i = 0; i < dispute.ableToVote.length; i++) {
            if (dispute.ableToVote[i] == judge) {
                return true;
            }
        }
        return false;
    }

    // ====================================
    //              OTHERS          
    // ====================================

    //Function that allows the contract to receive ETH
    receive() external payable { }

}