// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TellorMusic {
    
    // band and fans addresses
    // hardcode band address
    // address payable band = 0x;
    address payable fan_one;
    address payable fan_two;
    address payable fan_three;

    constructor(address payable _one, address payable _two, address payable _three) {
        fan_one = _one;
        fan_two = _two;
        fan_three = _three;
    }

    function balance() public view returns(uint) {
    return address(this).balance;

    }
}
