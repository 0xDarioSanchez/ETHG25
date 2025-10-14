// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/lancer-protocol/ProtocolContract.sol";


contract ProtocolContractTest is Test {
    ProtocolContract protocol;

    function setUp() public {
        protocol = new ProtocolContract(msg.sender, address(0x1234));
    }

    function testExample() public pure {
        assertTrue(true);
    }
}