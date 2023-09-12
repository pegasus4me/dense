import "hardhat/console.sol";
//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract Vault {
    
    struct Safe {
        uint256 id;
        string safeName; 
        string description;
        uint256 amountToReach; 
        string category; 
        bool reached; 
        address emitter;
    }

    Safe[] public safe;
    mapping(address => Safe[]) vaultsCreated;
    mapping(address => Safe[]) trackDonations;
    mapping(address => uint256) UserBalance;

    // ---------------------- / events / --------------------------
    event SafeCreated(); // when safe is created
    event SafeAmountReached();  // when safe reached his amountToreach
    event SafeClosed();  // when safe creator close this safe
    event SuccesContribured(); // when user send money that safe 

    // ------------------------------------------------------------

    receive()  external payable {
 
    }
    
    
    // -----------------------------------------------------
    //          SAFE CREATION AND MANTENACE LOGIC
    // -----------------------------------------------------
    function createNewSafe() external {}
    function updateSafe()    external {}
    function closeSafe()     external {}
    function contribute()    external {}

    
    //-----------------------------------------------------
    //          CONTRIBUTIONS RETURNS LOGIC
    // ----------------------------------------------------

    function getContributors() external view returns(address) {}
    function getTotalContributionAmount() external view returns(uint256){}
    function getContributionAmountBySafe() external view returns(uint256){}



}