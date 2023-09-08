//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./helper/ownable.sol";

contract Authentification is Ownable {
    
    struct Auth {
        string name;
        address wallet;
        string profilePic;
        string role;
    }

    mapping(address => Auth) users;

    function register(string memory _name, string memory _profilePic) external {
        // il faut que l'user soit pas deja enregistré
        require(
            users[msg.sender].wallet == address(0),
            "account with this informations already exist"
        );

        Auth memory newUser = Auth({
            name: _name,
            wallet: msg.sender,
            profilePic: _profilePic,
            role : "user"
        });

        // save the user in the mapping
        users[msg.sender] = newUser;
    }

    function getUser(address _address) external view returns(string memory, address, string memory){
        Auth memory user = users[_address];
        return (user.name, user.wallet, user.profilePic);


    }

    function updateUserDetails(string memory _newName, string memory _newProfilePic) external {
            
        require(
        users[msg.sender].wallet != address(0),
        "account with this informations not exist"
        );

        Auth memory updateUser = Auth({
            name : _newName,
            wallet : msg.sender,
            profilePic : _newProfilePic,
            role : "user"

        });

        users[msg.sender] = updateUser;

    }

    function deleteUser(address _address) external onlyOwner() {
            
        require(
            users[_address].wallet != address(0),
            "account with this informations not exist"
        );

        delete(users[_address]);

    }

    function changeRoles(address _address) external{
        
        require(
            users[_address].wallet != address(0),
            "account with this informations not exist"
        );
        
        // update role of user
        users[_address].role = "admin"; 

    }
}
