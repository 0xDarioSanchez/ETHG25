//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.30;


interface IProtocolContract {
    function createDispute(address requester, uint256 amount, string calldata reason) external;
}