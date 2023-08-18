<<<<<<< HEAD
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    constructor() ERC20("Reward Token", "RT") {
        _mint(msg.sender, 1000000 * 10**18);
    }
=======
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    constructor() ERC20("Reward Token", "RT") {
        _mint(msg.sender, 1000000 * 10**18);
    }
>>>>>>> 515b81b88610821789a402ff04da9cd50b8e712d
}