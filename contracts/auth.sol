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

    event Registered(uint256 _code, string message);
    event UpdateDetails(uint256 _code , string message, string _newName, string _newProfilePick);
    event UserDeleted(uint256 _code, string message, address _user);
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

        emit Registered(200, "succesfully registered");
    }

    /**
    @param _address the address of the creator of the profile     
    */
    function getUser(address _address) external view returns(string memory, address, string memory){
        Auth memory user = users[_address];
        require(user.wallet != address(0), "User not registered");
        return (user.name, user.wallet, user.profilePic);

    }


    // return bool if user is registered or not 
    function getifUserIsRegistered() external view returns(bool){
        if(users[msg.sender].wallet == address(0)) {
            return false;
        }
        return true;
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

        emit UpdateDetails(200, "details succesfully updated", _newName, _newProfilePic);
    }

    function deleteUser(address _address) external onlyOwner() {
            
        require(
            users[_address].wallet != address(0),
            "account with this informations not exist"
        );

        delete(users[_address]);

        emit UserDeleted(200, "user deleted", _address);

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
