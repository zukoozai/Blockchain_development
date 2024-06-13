

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract PharmaChain {
    struct TemperatureData {
        uint timestamp;
        uint temperature;
    }

    struct ProductInfo {
        string name;
        uint serialNumber;
        uint batchId;
        address manufacturer;
        uint expirationDate;
        mapping(address => TemperatureData[]) temperatureHistory;
    }

    mapping(uint => ProductInfo) public products;

    event ProductRegistered(uint serialNumber, address manufacturer);
    event TemperatureRecorded(uint serialNumber, address location, uint temperature);

    function registerProduct(string memory name, uint batchID, uint expirationDate) public {
        uint serialNumber = generateSerialNumber();
        ProductInfo storage newProduct = products[serialNumber];
        newProduct.name = name;
        newProduct.serialNumber = serialNumber;
        newProduct.batchId = batchID;
        newProduct.manufacturer = msg.sender;
        newProduct.expirationDate = expirationDate;
        emit ProductRegistered(serialNumber, msg.sender);
    }

    function recordTemperature(uint serialNumber, uint temperature) public {
        ProductInfo storage product = products[serialNumber];
        require(product.serialNumber > 0, "Invalid product serial number");
        product.temperatureHistory[msg.sender].push(TemperatureData(block.timestamp, temperature));
        emit TemperatureRecorded(serialNumber, msg.sender, temperature);
    }

    function generateSerialNumber() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender)));
    }
}