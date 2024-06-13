// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract GameNFT is ERC721 {

    mapping(uint => string) public nftData;
    uint private _totalSupply;

    constructor() ERC721("GameNFT", "GNFT") {}

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function mintNFT(address recipient, string memory data) public {
        uint tokenId = _totalSupply + 1;
        _mint(recipient, tokenId);
        nftData[tokenId] = data;
        _totalSupply++;
    }

    function transferNFT(address recipient, uint tokenId) public {
        _transfer(msg.sender, recipient, tokenId);
    }

}