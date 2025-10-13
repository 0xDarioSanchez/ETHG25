//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.30;

// ====================================
//              IMPORTS          
// ====================================

import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// import {MarketplaceInstance as Marketplace } from "./MarketplaceInstance.sol";
import "./interfaces/IPYUSD.sol";

// ====================================
//             INTERFACE          
// ====================================


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

    uint256 public keepAmount = 2 * 10**18; // 2 PYUSD kept in contract

    struct Judge {
        bool isRegistered;
        uint256 reputation;
    }

    struct Dispute {
        address requester;
        uint256 amount; // dispute fee paid
        string reason;
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        mapping(address => bool) voted;
        address[] votedForWinner; // judges that voted for winning side
    }

    mapping(address => Judge) public judges;
    Dispute[] public disputes;


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
    event DisputeCreated(uint256 indexed disputeId, address indexed requester);
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

    function registerJudge() external {
        require(!judges[msg.sender].isRegistered, "Already registered");
        judges[msg.sender] = Judge(true, 1);
        emit JudgeRegistered(msg.sender);
    }

    function createDispute(address requester, uint256 amount, string calldata reason) external {
        uint256 disputeId = disputes.length;
        disputes.push();
        Dispute storage d = disputes[disputeId];
        d.requester = requester;
        d.amount = amount;
        d.reason = reason;
        emit DisputeCreated(disputeId, requester);
    }

    function vote(uint256 disputeId, bool support) external {
        Dispute storage d = disputes[disputeId];
        Judge storage j = judges[msg.sender];
        require(j.isRegistered, "Not a judge");
        require(!d.voted[msg.sender], "Already voted");

        if(support){
            d.votesFor += j.reputation;
        } else {
            d.votesAgainst += j.reputation;
        }
        d.voted[msg.sender] = true;
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