//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "hardhat/console.sol";
import "./helper/ownable.sol";
import "./auth.sol";

contract CrowdFunding is Ownable {
    Authentification public authContract; 

    constructor(address _authAddress) {
        authContract = Authentification(_authAddress);
    }
    

}