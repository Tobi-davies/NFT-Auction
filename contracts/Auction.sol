// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/// @notice imported contracts from openzepplin as ERC721 standard
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


/// @author Tobiloba-Adebayo
/// @title Auction
/// @notice You can use this contract to auction NFTs
/// @dev All function calls are currently implemented without side effects
contract Auction {
 /// =================== VARIABLES ================================
    ///@dev struct of Auction Item with variables to track price , name and time
    struct Item {
        // uint id;
        address itemOwner;
        uint startingPrice;
        uint currentBid;
        string name;
        uint startAunction;
        uint endAuction;
        bool sold;
        // address payable owner;
        IERC721 nft;
        uint tokenId;
        address lastBid;
        Bid[] listofBids;

    }

///@dev struct of Bid with variables to track bidder and offer
    struct Bid {
        address bidder;
        uint256 offer;
    }

    ///@dev an array that returns ids of item(s)
    mapping(uint => Item) public items;
    ///@dev an array that returns itemsArray
    Item[] public itemsArray;
    uint private ID;
    ///@dev variable to track count of id in ids array
    uint[] private id;
    
    ///@dev an array that returns auctions by an address 
    mapping(address => uint) public auctionCount;


    ///======================= EVENTS & ERRORS ==============================
    ///@notice event to emit when item is added for auction
    event ItemAdded(uint itemId,string _name, uint256 _startingPrice,  address indexed nft, uint tokenId, address indexed seller);
    
    ///@notice event to emit when the bid is placed on an item
    event PlacedBid(uint itemId,string _name, uint256 offer, address indexed bidder);
    

 /// ======================= MODIFIERS =================================
    ///@notice modifier to check if bidding time is over
    modifier isBiddingOver(uint _id) {
        Item memory item = items[_id];
     require(item.endAuction >= block.timestamp, "Bidding time is over");
        _;
    }

    function addItemToAuction(IERC721 _nft, uint _tokenId,string memory _name, uint256 _startingPrice, uint duration) public  {
        require(_startingPrice > 0, "Price must be greater than zero");
        // uint count = auctionCount[msg.sender];
        _nft.transferFrom(msg.sender, address(this), _tokenId);

        Item storage item = items[ID];
        // item.id = ID;
        item.itemOwner = msg.sender;
        item.name= _name;
        item.startingPrice = _startingPrice;
        item.currentBid = 0;
        item.startAunction = block.timestamp;
        item.endAuction = block.timestamp + duration;
        itemsArray.push(item);
        auctionCount[msg.sender]++;

        uint _id = ID;
        id.push(_id);
        ID++;

        emit ItemAdded(_id, _name, _startingPrice,  address(_nft),  _tokenId, msg.sender);
    }
    
    function bidForItem (uint _id) public payable isBiddingOver(_id) {
        Item storage item = items[_id];
        require(!item.sold, "Item has been sold");
        require(item.itemOwner != msg.sender, "Item owner cannot bid");
        require(msg.value >= item.startingPrice && msg.value >= item.currentBid , "Item is priced higher that what you are offering");
        require(item.endAuction > block.timestamp, "Bidding time is over");
        Bid memory bid = Bid(msg.sender, msg.value);
        item.listofBids.push(bid);
        
        uint256 prevBidPrice = item.currentBid;
        // IT.currentBid = msg.value;
        address oudatedBidAddr = item.lastBid;
        payable(oudatedBidAddr).transfer(prevBidPrice);

        item.lastBid = msg.sender;
        item.currentBid = msg.value;


         emit PlacedBid(_id, item.name, msg.value, msg.sender);

    }


    function withdraw (uint _id) public {
        Item memory item = items[_id];
        require(item.itemOwner == msg.sender, "You are not the owner");
        require(block.timestamp >= item.endAuction, "Bidding time is not over");
        // item.sold = !item.sold;
        soldStatus(_id);
        payable(item.itemOwner).transfer(item.currentBid);
    }

    function soldStatus (uint _id) internal  {
        Item storage item = items[_id];
        require(item.itemOwner == msg.sender, "only owner can change status");
        require(!item.sold, "Item sold");
         item.sold = true;
         item.nft.transferFrom(address(this), item.lastBid, item.tokenId);

    }

    function getAllAuctionItems() public view returns(Item[] memory _itemsArray){
        uint[] memory all = id;
        _itemsArray = new Item[](all.length);

        for(uint i; i < all.length; i++){
            _itemsArray[i] = items[all[i]];
        }

    }
    


}













// contract Auction {
//     struct Item {
//         address itemOwner;
//         uint startingPrice;
//         uint currentPrice;
//         string name;
//         uint startAunction;
//         uint endAuction;
//         bool sold;
//     }

//     // mapping(uint => Item) public items;
//     mapping(address => mapping(uint => Item)) public items;
//     mapping(uint => Item) public itemsPublic;
//     Item[] public itemsArray;
//     uint private ID;
//     uint[] private id;

//     modifier isBiddingOver(uint _id, address _owner) {
//         Item memory item = items[_owner][_id];
//      require(item.endAuction >= block.timestamp, "Bidding time is over");
//         _;
//     }

//     function addItemToBid(string memory _name, uint256 _startingPrice, uint duration) public  {
//         Item storage item = items[msg.sender][ID];
//         item.itemOwner = msg.sender;
//         item.name= _name;
//         item.startingPrice = _startingPrice;
//         item.currentPrice = 0;
//         item.startAunction = block.timestamp;
//         item.endAuction = block.timestamp + duration;
//         itemsArray.push(item);

//         Item storage IP = itemsPublic[ID];
//          IP.itemOwner = msg.sender;
//         IP.name= _name;
//         IP.startingPrice = _startingPrice;
//         IP.currentPrice = 0;
//         IP.startAunction = block.timestamp;
//         IP.endAuction = block.timestamp + duration;
//         uint _id = ID;
//         id.push(_id);
//         ID++;
//     }
    
//     function bidForItem (uint _id, address _owner) public payable isBiddingOver(_id, _owner) {
//         Item storage item = items[_owner][_id];
//         // Item[] storage IT = itemsArray[_id];
//         require(!item.sold, "Item has been sold");
//         require(item.itemOwner != msg.sender, "Item owner cannot bid");
//         require(msg.value >= item.startingPrice && msg.value >= item.currentPrice , "Item is priced higher that what you are offering");
//         // require(item.endAuction >= block.timestamp, "Bidding time is over");

//         item.currentPrice = msg.value;
//         // IT.currentPrice = msg.value;

//         Item storage IP = itemsPublic[_id];
//         IP.currentPrice = msg.value;

//     }

//     function withdraw (uint _id) public {
//         Item memory item = items[msg.sender][_id];
//         require(item.itemOwner == msg.sender, "You are not the owner");
//         require(block.timestamp >= item.endAuction, "Bidding time is over");
//         // item.sold = !item.sold;
//         soldStatus(_id);
//         payable(item.itemOwner).transfer(item.currentPrice);
//     }

//     function soldStatus (uint _id) internal  {
//         Item storage item = items[msg.sender][_id];
//          item.sold = !item.sold;

//          Item storage IP = itemsPublic[_id];
//          IP.sold = !item.sold;

//     }

//     function getAllAuctionItems() public view returns(Item[] memory _itemsArray){
//         uint[] memory all = id;
//         _itemsArray = new Item[](all.length);

//         for(uint i; i < all.length; i++){
//             _itemsArray[i] = itemsPublic[all[i]];
//         }

//         // return itemsArray;
//     }

    

//     // function getAllBeneficiary() external view returns(BeneficiaryProperties[] memory _bp){
//     //     uint[] memory all = id;
//     //     _bp = new BeneficiaryProperties[](all.length);

//     //     for(uint i; i < all.length; i++){
//     //         _bp[i] = _beneficiaryProperties[all[i]];
//     //     }
//     // }

// }