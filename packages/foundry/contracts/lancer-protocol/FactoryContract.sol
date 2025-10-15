//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.30;

// ====================================
//              IMPORTS          
// ====================================

import "forge-std/console.sol";

import {MarketplaceInstance as Marketplace } from "./MarketplaceInstance.sol";

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
contract FactoryContract {

    // ====================================
    //          STATE VARIABLES          
    // ====================================

    mapping(address => bool) public isMarketplace;

    // ====================================
    //             MODIFIERS          
    // ====================================


    // ====================================
    //              EVENTS          
    // ====================================

    event MarketplaceDeployed(address indexed marketplace, address indexed creator);

    // ====================================
    //           CUSTOM ERRORs          
    // ====================================

    // ====================================
    //           CONSTRUCTOR          
    // ====================================

    constructor() {
    }

    // ====================================
    //         EXTERNAL FUNCTIONS          
    // ====================================

    // ====================================
    //          PUBLIC FUNCTIONS          
    // ====================================

    function createMarketplace( uint256 _feePercent, address _token, address _protocol) external returns (address) {
        Marketplace newMarketplace = new Marketplace(msg.sender, _feePercent, _token, _protocol);
        isMarketplace[address(newMarketplace)] = true;

        emit MarketplaceDeployed(address(newMarketplace), msg.sender);
        return address(newMarketplace);
    }


    // ====================================
    //        PURE & VIEW FUNCTIONS          
    // ====================================

    function isDeployedMarketplace(address _marketplace) external view returns (bool) {
        return isMarketplace[_marketplace];
    }

    // ====================================
    //              OTHERS          
    // ====================================

    //Function that allows the contract to receive ETH
    receive() external payable { }

}
