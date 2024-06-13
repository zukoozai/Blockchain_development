

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SupplyChainToken is ERC20 {

    constructor() ERC20("SupplyChainToken", "SCT")  {}

    mapping(uint => string) public productDetails;

    function mintProduct(string memory details, uint amount) public {
        _mint(msg.sender, amount);
        productDetails[totalSupply()] = details;
    }

    function transferProduct(address recipient, uint amount) public {
        _transfer(msg.sender, recipient, amount);
    }

    function getProductDetails(uint tokenId) public view returns(string memory) {
        return productDetails[tokenId];
    }

}