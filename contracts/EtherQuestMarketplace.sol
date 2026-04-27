// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title EtherQuestMarketplace
 * @author Derin Yüksel
 * @notice Smart contract handling ownership and trading of in-game items
 *         for the EtherQuest fantasy RPG. Built for Fundamentals of
 *         Blockchain course.
 */
contract EtherQuestMarketplace {
    
    // ============ DATA STRUCTURES ============
    
    /**
     * @dev Represents a single in-game item.
     *      All item data lives on-chain so the item survives even if
     *      the game studio shuts down.
     */
    struct Item {
        uint256 id;
        string name;         
        string itemType;     
        string rarity;      
        uint256 attackPower;
        uint256 defensePower;
        uint256 price;        // price in wei 
        address owner;
        bool forSale;
        bool exists;          // distinguishes "no item" from "item with id 0"
    }
    
    // ============ STATE VARIABLES ============
    
    address public gameAdmin;     
    uint256 public nextItemId;    // Auto-incrementing ID for new items
    
    // itemId => Item details
    mapping(uint256 => Item) public items;
    
    // player address => list of item IDs they own
    mapping(address => uint256[]) private playerInventory;
    
    // ============ CONSTRUCTOR ============
    
    /**
     * @dev Runs once when the contract is deployed.
     *      The deployer becomes the game admin.
     */
    constructor() {
        gameAdmin = msg.sender;
        nextItemId = 1;
    }
    
    // ============ ADMIN FUNCTIONS ============
    
    /**
     * @notice Creates a new item in the game world. Only the game admin
     *         can call this (this would be the game studio in production).
     */
    function createItem(
        string memory _name,
        string memory _itemType,
        string memory _rarity,
        uint256 _attackPower,
        uint256 _defensePower,
        uint256 _price
    ) public {
        require(msg.sender == gameAdmin, "Only the game admin can create items");
        
        items[nextItemId] = Item({
            id: nextItemId,
            name: _name,
            itemType: _itemType,
            rarity: _rarity,
            attackPower: _attackPower,
            defensePower: _defensePower,
            price: _price,
            owner: gameAdmin,
            forSale: true,
            exists: true
        });
        
        playerInventory[gameAdmin].push(nextItemId);
        nextItemId++;
    }
    
    // ============ PLAYER FUNCTIONS ============
    
    /**
     * @notice Buy an item that's currently listed for sale.
     *         Payment is sent in ETH (wei) and forwarded to the seller.
     */
    function buyItem(uint256 _itemId) public payable {
        require(items[_itemId].exists, "Item does not exist");
        require(items[_itemId].forSale, "Item is not for sale");
        require(msg.value >= items[_itemId].price, "Not enough ETH sent");
        require(items[_itemId].owner != msg.sender, "You already own this item");
        
        address previousOwner = items[_itemId].owner;
        
        // Transfer ETH to previous owner
        payable(previousOwner).transfer(msg.value);
        
        // Update ownership on-chain
        items[_itemId].owner = msg.sender;
        items[_itemId].forSale = false;
        
        // Add to new owner's inventory
        playerInventory[msg.sender].push(_itemId);
    }
    
    /**
     * @notice The current owner lists their item for sale at a chosen price.
     */
    function listItemForSale(uint256 _itemId, uint256 _newPrice) public {
        require(items[_itemId].exists, "Item does not exist");
        require(items[_itemId].owner == msg.sender, "You don't own this item");
        
        items[_itemId].price = _newPrice;
        items[_itemId].forSale = true;
    }
    
    /**
     * @notice Gift an item directly to another player (no payment).
     *         Useful for trades, guild rewards, friend gifts.
     */
    function giftItem(uint256 _itemId, address _to) public {
        require(items[_itemId].exists, "Item does not exist");
        require(items[_itemId].owner == msg.sender, "You don't own this item");
        require(_to != address(0), "Cannot gift to the zero address");
        
        items[_itemId].owner = _to;
        items[_itemId].forSale = false;
        playerInventory[_to].push(_itemId);
    }
    
    // ============ VIEW FUNCTIONS ============
    
    /**
     * @notice Returns all data for a specific item.
     */
    function getItem(uint256 _itemId) public view returns (Item memory) {
        require(items[_itemId].exists, "Item does not exist");
        return items[_itemId];
    }
    
    /**
     * @notice Returns the list of item IDs owned by the caller.
     */
    function getMyInventory() public view returns (uint256[] memory) {
        return playerInventory[msg.sender];
    }
    
    /**
     * @notice Returns the list of item IDs owned by any address.
     */
    function getInventoryOf(address _player) public view returns (uint256[] memory) {
        return playerInventory[_player];
    }
}