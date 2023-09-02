// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract StakingContract is Ownable {
    using SafeMath for uint256;

    IERC20 public stakingToken;
    uint256 public yieldRate; // APY in tenths of a percent (e.g., 5% as 500)
    uint256 public totalStaked;
    mapping(address => uint256) public userStakes;
    mapping(address => uint256) public userLastUpdate;

    constructor(address _stakingToken, uint256 _yieldRate) {
        stakingToken = IERC20(_stakingToken);
        yieldRate = _yieldRate;
    }

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 yield);

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(stakingToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        updateYield(msg.sender);

        userStakes[msg.sender] = userStakes[msg.sender].add(amount);
        totalStaked = totalStaked.add(amount);

        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(userStakes[msg.sender] >= amount, "Insufficient staked balance");

        updateYield(msg.sender);

        uint256 yield = calculateYield(msg.sender, amount);

        userStakes[msg.sender] = userStakes[msg.sender].sub(amount);
        totalStaked = totalStaked.sub(amount);

        require(stakingToken.transfer(msg.sender, amount.add(yield)), "Transfer failed");

        emit Unstaked(msg.sender, amount, yield);
    }

    function updateYield(address user) internal {
        uint256 timeElapsed = block.timestamp.sub(userLastUpdate[user]);
        uint256 yieldEarned = userStakes[user].mul(yieldRate).mul(timeElapsed).div(365 days).div(1000);
        userStakes[user] = userStakes[user].add(yieldEarned);
        userLastUpdate[user] = block.timestamp;
    }

    function calculateYield(address user, uint256 amount) internal view returns (uint256) {
        uint256 timeElapsed = block.timestamp.sub(userLastUpdate[user]);
        return userStakes[user].mul(yieldRate).mul(timeElapsed).mul(amount).div(365 days).div(1000).div(userStakes[user]);
    }

    function getUserTotalBalance(address user) external view returns (uint256) {
        return userStakes[user].add(calculateYield(user, userStakes[user]));
    }
}
