// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MultiToken is ERC1155 {
    
    mapping(uint => uint) public totalSupply;

    constructor(string memory uri) ERC1155(uri) {}

    function addTokenType(uint initialSupply) public {
        uint tokenId = totalSupply[0];
        totalSupply[tokenId] = initialSupply;
        _mint(address(this), tokenId, initialSupply, "");
    }

    function transferTokens(address recipient, uint[] memory ids, uint[] memory amounts) public {
        _safeBatchTransferFrom(msg.sender, recipient, ids, amounts, "");
    }

    function burnTokens(uint id, uint amount) public {
        require(balanceOf(msg.sender, id) >= amount, "Insufficient balance to burn");
        _burn(msg.sender, id, amount);
        totalSupply[id] -= amount;
    }

    function gettotalSupply(uint id) public view returns(uint) {
        return totalSupply[id];
    }

}