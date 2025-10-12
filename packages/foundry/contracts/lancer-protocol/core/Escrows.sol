//SPDX-License-Identifier: Apache-2.0

pragma solidity 0.8.30; 

// ====================================
//              IMPORTS          
// ====================================

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { LancerTypes } from "../libraries/LancerTypes.sol";
import { LancerErrors } from "../libraries/LancerErrors.sol";


// ====================================
//              CONTRACT          
// ====================================

contract Escrows {

    // ====================================
    //          STATE VARIABLES          
    // ====================================

    address public immutable owner;
    address public immutable token; // PYUSD address
    mapping(bytes32 => LancerTypes.Escrow) public escrows;

    // ====================================
    //              MODIFIERS          
    // ====================================

    modifier onlyPayer(bytes32 escrowId) {
        require(msg.sender == escrows[escrowId].payer, "Only payer can perform this action");
        _;
    }

    modifier onlyReceiver(bytes32 escrowId) {
        require(msg.sender == escrows[escrowId].receiver, "Only receiver can perform this action");
        _;
    }

    modifier escrowExists(bytes32 escrowId) {
        require(escrows[escrowId].amount > 0, "Escrow does not exist");
        _;
    }

    modifier notReleased(bytes32 escrowId) {
        require(!escrows[escrowId].accepted, "Escrow already released");
        _;
    }

    // ====================================
    //              EVENTS         
    // ====================================

    event EscrowCreated(bytes32 indexed escrowId, address indexed payer, address indexed receiver, uint256 amount);
    event EscrowReleased(bytes32 indexed escrowId);
    event EscrowCancelled(bytes32 indexed escrowId);

    // ====================================
    //           CUSTOM ERRORs          
    // ====================================


    // ====================================
    //           CONSTRUCTOR          
    // ====================================

    constructor(address _token, address _owner) {
        token = _token;
        owner = _owner;
    }

    // ====================================
    //        EXTERNAL FUNCTIONS          
    // ====================================

    function createEscrow(bytes32 escrowId, address receiver, uint256 amount) external payable {
        require(escrows[escrowId].amount == 0, "Escrow already exists");
        require(amount > 0, "Amount must be greater than zero");
        require(receiver != address(0), "Invalid receiver address");

        escrows[escrowId] = LancerTypes.Escrow({
            payer: msg.sender,
            receiver: receiver,
            amount: amount,
            createdAt: block.timestamp,
            accepted: false,
            disputed: false
        });

        emit EscrowCreated(escrowId, msg.sender, receiver, amount);
    }

    function acceptEscrow(bytes32 escrowId) external onlyPayer(escrowId) escrowExists(escrowId) notReleased(escrowId) {
        LancerTypes.Escrow storage escrow = escrows[escrowId];
        escrow.accepted = true;

        IERC20(token).transfer(escrow.receiver, escrow.amount); 

        emit EscrowReleased(escrowId);
    }

    function cancelEscrow(bytes32 escrowId) external onlyPayer(escrowId) escrowExists(escrowId) notReleased(escrowId) {
        LancerTypes.Escrow storage escrow = escrows[escrowId];
        escrow.accepted = false;
        delete escrows[escrowId];

        emit EscrowCancelled(escrowId);
    }  

    // ====================================
    //          PUBLIC FUNCTIONS          
    // ====================================

    // ====================================
    //        PURE & VIEW FUNCTIONS          
    // ==================================== 
}