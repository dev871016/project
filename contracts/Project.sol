// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Project is ReentrancyGuard {
    uint256 public totalBalance;
    uint256 public profit;
    uint256 public operationPercent;
    address owner;
    address public token;
    string public name;
    string public location;
    string public description;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public rewards;
    mapping(address => bool) public isStaker;
    address[] public stakers;

    modifier onlyOwner(address _owner) {
        require(_owner == msg.sender, "Invalid owner!");
        _;
    }

    constructor(
        address _owner,
        address _token,
        string memory _name,
        string memory _location,
        string memory _description,
        uint256 _totalBalance
    ) {
        owner = _owner;
        token = _token;
        name = _name;
        location = _location;
        description = _description;
        totalBalance = _totalBalance;
        balances[address(this)] = _totalBalance;
    }

    function transfer(address to, uint256 amount) public onlyOwner(token) {
        require(amount < balances[address(this)], "Invalid amount!");

        balances[address(this)] -= amount;
        balances[to] += amount;
        rewards[owner] += amount;
        if (!isStaker[to]) {
            isStaker[to] = true;
            stakers.push(to);
        }
    }

    function addProfit(uint256 amount) public {
        profit += amount;
    }

    function distributeProfit() public {
        uint256 reward;
        uint256 rewardSpent;
        address staker;
        for (uint256 i = 0; i < stakers.length; i++) {
            staker = stakers[i];
            reward = (balances[staker] * profit) / totalBalance;
            rewards[staker] += reward;
            rewardSpent += reward;
        }
        profit -= rewardSpent;
        rewards[owner] += profit;
        profit = 0;
    }

    function withdraw() public nonReentrant {
        bool success = IERC20(token).transfer(msg.sender, rewards[msg.sender]);
        if (success) {
            rewards[msg.sender] = 0;
        }
    }
}
