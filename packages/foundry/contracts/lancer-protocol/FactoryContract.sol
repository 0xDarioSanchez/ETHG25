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

    address[] public marketplaces;

    // ====================================
    //             MODIFIERS          
    // ====================================


    // ====================================
    //              EVENTS          
    // ====================================

    event MarketplaceCreated(address indexed marketplace, address indexed creator);

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

    function createMarketplace( uint256 _feePercent, address _token) external {
        Marketplace newMarketplace = new Marketplace(msg.sender, _feePercent, _token);
        marketplaces.push(address(newMarketplace));

        emit MarketplaceCreated(address(newMarketplace), msg.sender);
    }


    // ====================================
    //        PURE & VIEW FUNCTIONS          
    // ====================================

    function getMarketplaces() external view returns(address[] memory) {
        return marketplaces;
    }

    // ====================================
    //              OTHERS          
    // ====================================

    //Function that allows the contract to receive ETH
    receive() external payable { }

}
