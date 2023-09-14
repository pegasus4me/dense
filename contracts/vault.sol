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

    struct Donator {
        uint256 id; 
        address emitter; 
        uint256 value; 
    }

    Safe[] public safe;
    Donator[] public donator; 

    mapping(address => Safe[]) vaultsCreated;
    mapping(address => Safe[]) vaultClosed; 
    mapping(address => Donator[]) trackDonations;  // track donators in a array
    mapping(address => uint256) userBalance;  // update the contributors balance after donations
    mapping(address => uint256) safeBalance;  // update de safeBalance

    // ---------------------- / events / --------------------------
    event SafeCreated(uint64 code, string message, uint256 safeId); // when safe is created
    event SafeUpdated(uint64 code, string messsage, string _name, string _description , uint256 amount);
    event SafeClosed(uint64 code, string message, uint256 safeIndex); // when safe creator close this safe
    event SafeAmountReached(uint64 code , string message, uint256 _amount); // when safe reached his amountToreach
    event SuccesContribured(uint56 code, string message, address contibutor); // when user send money that safe
    
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
        emit SafeClosed(200, "safe closed", indexToDelete);
        

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
    

    
    // function contribute has to be avalaible for each safe and has to know what safe are dealing with to succesfully transfer money in a correst safe
    function contribute(uint256 _id, uint256 _amount) external payable {

        // verify if the user has enougth money in their wallet
        require(address(msg.sender).balance > _amount, "you can't send more than you have!");
        // recuper l'addresse du contract
        Safe memory findSafeId = findSafeById(msg.sender, _id);
        require(findSafeId.id == _id, "safe not found");
        
        
        // send money to an Safe 
        if(findSafeId.currentBalance < findSafeId.amountToReach) {
            
            (bool sent, bytes memory data) = payable(address(findSafeId.emitter)).call{value : msg.value}("");
            require(sent, "failed to send eth");
            // trigger event succesfullyContributed
            emit SuccesContribured(200, "succesfully Contributed", msg.sender);
            // update the safe balance
            findSafeId.currentBalance += _amount;
        } else {
            revert("you can't fund this safe, cause : amout already reached");
        }

        // update the reacher value in struct when safe balance == amountToReach 
        if(findSafeId.currentBalance >= findSafeId.amountToReach) {
            
            findSafeId.reached = true;
            // emit events
            emit SafeAmountReached(200, "amount reached", findSafeId.currentBalance);
        }

        // update mappings
        safeBalance[address(this)] += _amount;
        userBalance[msg.sender] -= _amount;
        
        //////////////////////

        uint256 id = block.timestamp;
        
        Donator memory newDonators = Donator({
            id : id, 
            emitter : msg.sender, 
            value: _amount
        });

        trackDonations[address(this)].push(newDonators);
        donator.push(newDonators);

    }
    
    function findSafeById(address _user, uint256 _id) internal view returns(Safe memory) {
        Safe[] storage userSafe =  vaultsCreated[_user];
        for (uint256 index = 0; index < userSafe.length; index++) {
            if(userSafe[index].id == _id) {
                return userSafe[index];
            }
        }
        revert("safe not found");
    }

    //-----------------------------------------------------
    //          CONTRIBUTIONS RETURNS LOGIC 
    // ----------------------------------------------------

    function getAllContributors() external view returns (Donator[] memory) {
        return donator;
    }
    
    // function getTotalContributionAmount() external view returns (uint256) {}

    // function getContributionAmountBySafe() external view returns (uint256) {}
}
