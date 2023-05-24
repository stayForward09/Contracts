// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.8.0/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts@4.8.0/utils/Context.sol";

contract Presale {
    address private admin;
    uint private startTime;
    uint private endTime;
    uint private amount;
    address private bydToken;
    address private usdtToken;


    modifier onlyAdmin() {
        require(msg.sender == admin, "No right to access.");
        _;
    }

    modifier  timecheck(uint _nowTime) {
        require(_nowTime > startTime && _nowTime <= endTime, "Time is expired.");
        _;
    }

    constructor(address _byd, address _usdt) {
        startTime = 0;
        endTime = 0;
        amount = 100000000000000000000000;
        admin = msg.sender;
        bydToken = _byd;
        usdtToken = _usdt;
    }

    function start() public onlyAdmin {
        startTime = block.timestamp;
        endTime = block.timestamp + 18000;
    }

    function sale() public timecheck(block.timestamp) {
        IERC20(usdtToken).transferFrom(msg.sender, address(this), amount);
        IERC20(bydToken).transfer(msg.sender, amount);
    }

    function withdraw() public onlyAdmin {
        uint adminBalance = IERC20(usdtToken).balanceOf(address(this));
        IERC20(usdtToken).transferFrom(address(this), admin, adminBalance);
    }
}

