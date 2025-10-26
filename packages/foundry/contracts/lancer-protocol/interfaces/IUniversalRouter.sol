// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

interface IUniversalRouter {
    function execute(bytes calldata commands, bytes[] calldata inputs) external payable;
    function execute(bytes calldata commands, bytes[] calldata inputs, uint256 deadline) external payable;
}