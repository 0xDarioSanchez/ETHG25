//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.30;

import "forge-std/console.sol";

// Use openzeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
// import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * A smart contract that allows changing a state variable of the contract and tracking the changes
 * It also allows the owner to withdraw the Ether in the contract
 * @author BuidlGuidl
 */
contract ProtocolContract {
    // State Variables
    address public immutable owner;

    constructor(address _owner) {
        owner = _owner;
    }

    // Modifier: used to define a set of rules that must be met before or after a function is executed
    modifier isOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }


}
