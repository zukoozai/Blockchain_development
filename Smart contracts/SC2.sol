// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract SupplyChain {
    
    enum Stage { Harvested, InTransport, Processing, Storage, Retail }

    struct Product {
        uint256 productId;
        address payable owner;
        Stage currentStage;
        mapping(uint8 => bytes32) data;
    }

    mapping(uint256 => Product) public products;

    event ProductRegistered(uint256 productId, address owner);

    function registerProduct(bytes32[] memory _iniData) public {
        uint256 productId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _iniData)));
        Product storage product = products[productId];
        product.productId = productId;
        product.owner = payable(msg.sender);
        product.currentStage = Stage.Harvested;
        for (uint8 i = 0; i < uint8(_iniData.length); i++) {
            product.data[i] = _iniData[i];
        }
        emit ProductRegistered(productId, msg.sender);
    }

    function updateProductData(uint256 _productId, Stage _stage, bytes32 _data) public {
        Product storage product = products[_productId];
        require(product.owner == msg.sender, "Only owner can update data");
        require(uint256(product.currentStage) < uint256(_stage), "Invalid stage transition");
        product.data[uint8(_stage)] = _data;
        product.currentStage = _stage;
    }

    function transferOwnership(uint256 _productId, address payable _newOwner) public {
        Product storage product = products[_productId];
        require(product.owner == msg.sender, "Only owner can transfer ownership");
        product.owner = _newOwner;
    }
}