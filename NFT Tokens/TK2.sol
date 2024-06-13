// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FractionalRealEstate {
    struct Property {
        string propertyAddress;
        uint totalArea;
        uint tokenPrice;
    }

    struct Ownership {
        address owner;
        uint tokenOwned;
    }

    mapping(uint => Property) public properties;
    mapping(uint => mapping(address => Ownership)) public ownershipData;
    uint public numProperties;

    event PropertyTokenized(uint propertyId, string propertyAddress, uint totalArea, uint tokenPrice);
    event NFTSold(uint propertyId, address buyer, uint tokensPurchased);
    event RentDistributed(uint propertyId, uint totalRent);

    function tokenizeProperty(string memory _propertyAddress, uint _totalArea, uint _tokenPrice) public {
        numProperties++;
        properties[numProperties] = Property(_propertyAddress, _totalArea, _tokenPrice);
        emit PropertyTokenized(numProperties, _propertyAddress, _totalArea, _tokenPrice);
    }

    function buyNFT(uint propertyId) public payable {
        Property storage property = properties[propertyId];
        require(msg.value >= property.tokenPrice, "Insufficient funds for NFT purchase");

        uint tokensPurchased = msg.value / property.tokenPrice;
        ownershipData[propertyId][msg.sender].owner = msg.sender;
        ownershipData[propertyId][msg.sender].tokenOwned += tokensPurchased;
        emit NFTSold(propertyId, msg.sender, tokensPurchased);
    }

    function distributeRent(uint propertyId, uint totalRent) public {
        Property storage property = properties[propertyId];
        uint totalOwnedTokens = 0;
        address[] memory owners = new address[](numProperties);
        
        for (uint i = 1; i <= numProperties; i++) {
            address ownerAddress = ownershipData[propertyId][msg.sender].owner;
            owners[i - 1] = ownerAddress;
            totalOwnedTokens += ownershipData[propertyId][ownerAddress].tokenOwned;
        }

        for (uint i = 0; i < owners.length; i++) {
            address ownerAddress = owners[i];
            uint amount = (totalRent * ownershipData[propertyId][ownerAddress].tokenOwned) / totalOwnedTokens;
            payable(ownerAddress).transfer(amount);
        }

        emit RentDistributed(propertyId, totalRent);
    }
}