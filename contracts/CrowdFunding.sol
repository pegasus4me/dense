//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "hardhat/console.sol";
import "./helper/ownable.sol";
import "./auth.sol";
import "./vault.sol";

contract CrowdFunding is Ownable {
    // Authentification manage auth process logic for CrowdFunding
    Authentification public authContract; 
    // vault is the contract who manage the crowdfund logic 
    Vault public vault; 


    constructor(address _authAddress) {
        authContract = Authentification(_authAddress);
    }
    // --------------------------------------------------------
    //             REGISTRATION LOGIC FROM AUTH.SOL
    // ________________________________________________________
    function registerUser(string memory _name, string memory _profilePic) external{
        authContract.register(_name, _profilePic);
    }

    function UpdateUser(string memory _newName, string memory _newProfile) external { 
        authContract.updateUserDetails(_newName, _newProfile);
    }

    function Delete(address _address) external onlyOwner(){
        authContract.deleteUser(_address);
    }

    function getUser(address _address) external view returns(string memory, address, string memory ){
        (string memory name, address wallet, string memory profilePic) = authContract.getUser(_address);
        return (name, wallet, profilePic);
    }
        
    function checkIfRegistered() external view returns(bool){
        return authContract.getifUserIsRegistered();
    }

    function changeRoles(address _address) internal onlyOwner(){
        authContract.changeRoles(_address);
    }

    // ---------------------------------------------------------------
    //              VAULT FROM VAULT.SOL  
    // _______________________________________________________________



}