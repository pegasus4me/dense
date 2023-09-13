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
        uint256 currentBalance;
    }

    Safe[] public safe;

    mapping(address => Safe[]) vaultsCreated;
    mapping(address => Safe[]) vaultClosed; 
    mapping(address => Safe[]) trackDonations;
    mapping(address => uint256) userBalance;
    mapping(uint256 => uint256) safeBalance;

    // ---------------------- / events / --------------------------
    event SafeCreated(uint64 code, string message, uint256 safeId); // when safe is created
    event SafeUpdated(uint64 code, string messsage, string _name, string _description , uint256 amount);
    event SafeAmountReached(); // when safe reached his amountToreach
    event SafeClosed(); // when safe creator close this safe
    event SuccesContribured(); // when user send money that safe
    
    receive() external payable {}
    
    // ------------------------/ MODFIERS /--------------------------------
    modifier onlyVault {
        require(vaultsCreated[msg.sender].length > 0, "0 safe founds");
        _;
    }

    modifier checkIfSafeExist(uint256 _id) {
        
        bool checkPoint = false;
        for (uint256 index = 0; index < vaultsCreated[msg.sender].length; index++) {
            if(vaultsCreated[msg.sender][index].id == _id) {
                checkPoint  = true;
            }
        }

        require(checkPoint, "safe Not Found");
        _;
    }

    // -----------------------------------------------------
    //          SAFE CREATION AND MANTENACE LOGIC
    // -----------------------------------------------------

    /**
    @param _safeName the name of the safe
    @param _description the description of the safe
    @param _amount the target amount we want to reach for this safe
    @param _category the cat or the safe
    */
    
    function createNewSafe(
        string memory _safeName,
        string memory _description,
        uint256 _amount,
        string memory _category
    ) external {
        uint256 id = block.timestamp;

        Safe memory newSafe = Safe({
            id: id,
            safeName: _safeName,
            description: _description,
            amountToReach: _amount,
            category: _category,
            emitter: msg.sender,
            reached: false, // by default reached is set to false
            currentBalance: 0
        });
        vaultsCreated[msg.sender].push(newSafe);
        safe.push(newSafe); // to have all safes in one array

        emit SafeCreated(200, "safe created", id);
    }

    /**
    @param _id = id of the current safe
    @param _safeName new name
    @param _description nes description
    @param _newAmount new amount to reach

    */
    function updateSafe(
        uint256 _id,
        string memory _safeName,
        string memory _description,
        uint _newAmount,
        string memory _category
    ) external {
        // faut que le safe existe

        require(vaultsCreated[msg.sender].length > 0, "0 safe founds");

        bool safeFound = false;

        for (
            uint256 index = 0;
            index < vaultsCreated[msg.sender].length;
            index++
        ) {
            if (vaultsCreated[msg.sender][index].id == _id) {
                vaultsCreated[msg.sender][index].safeName = _safeName;
                vaultsCreated[msg.sender][index].description = _description;
                vaultsCreated[msg.sender][index].amountToReach = _newAmount;
                vaultsCreated[msg.sender][index].category = _category;
                safeFound = true;
                emit SafeUpdated(200, "safe updated", _safeName, _description, _newAmount);
                break;
            }
        }
    }

    function closeSafe(uint256 _id) external checkIfSafeExist(_id) {
        // get the index of the concerned safe with this function call
        uint256 indexToDelete  = findSafeIndex(_id);
        // check if our index is less than the current mapping length array
        require(indexToDelete < vaultsCreated[msg.sender].length); 
        // delete the concerned safe
        delete(vaultsCreated[msg.sender][indexToDelete]);
        // add this safe to the vaultClosedMapping
        vaultClosed[msg.sender].push(vaultsCreated[msg.sender][indexToDelete]);

    }
    // function utilisé pour 
    function findSafeIndex(uint256 _id) internal view returns(uint256) {
        for (uint256 index = 0; index < vaultsCreated[msg.sender].length; index++) {
            if(vaultsCreated[msg.sender][index].id == _id){
                return index;
            }
        }
        revert("Safe not found!");
    }

    function contribute() external payable {

        // verify if the user has enougth money in their wallet
        // send money to an Safe 
        // update the safe balance
        // update the reacher value in struct when safe balance == amountToReach 
    }

    //-----------------------------------------------------
    //          CONTRIBUTIONS RETURNS LOGIC
    // ----------------------------------------------------

    function getContributors() external view returns (address) {}

    function getTotalContributionAmount() external view returns (uint256) {}

    function getContributionAmountBySafe() external view returns (uint256) {}
}
