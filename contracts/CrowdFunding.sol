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


    constructor(address _authAddress, address payable _vaultAddress) {
        authContract = Authentification(_authAddress);
        vault = Vault(_vaultAddress);
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

    // create Safe
    function createSafe(
        string memory _safeName,
        string memory _description,
        uint256 _amount,
        string memory _category

    ) external {
         vault.createNewSafe(_safeName, _description, _amount, _category);
    }

    // update Specific Safe
    function updateSafe(
        uint256 _id,
        string memory _safeName,
        string memory _description,
        uint _newAmount,
        string memory _category
    ) external {
        vault.updateSafe(_id, _safeName, _description, _newAmount, _category);
    }
    
    // delete Specific Safe created
    function deleteSafe(
        uint256 _id
    ) external {
        vault.closeSafe(_id);
    }
    // deposit
    function deposit() external {
        vault.deposit();
    }
    // contribute
    function contribute(
        uint256 _id,
        uint256 _amount
    ) external {
        vault.contribute(_id, _amount);
    }
    // return the balance 
    function balanceOf() external view returns(uint256){
        return vault.balanceOf();
    }
    // get the vaults creates by the users
    function vaultCreatedByUser() external view returns(Vault.Safe[] memory){
        return vault.vaultcreatedbyuser();
    }
   
}