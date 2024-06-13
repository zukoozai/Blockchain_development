// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DAGG is ERC721("DAGG NFT", "DAGG") {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenCounter;
    uint public treasuryBalance;
    mapping(address => uint[]) public borrowedNFTs;
    event NFTAcquired(uint tokenId, string name);
    event NFTBorrowed(uint tokenId, address borrower);
    uint public membershipFee;
    address payable public marketplace;
    uint public nftPrice;
    string public nftName;
    uint public nftTokenId;
    address public nftOwner;
    uint public nftBalance;
    uint public totalNFTSupply;
    uint public nftDistribution;
    uint public nftDistributionPercentage;
    uint public nftDistributionAmount;
    address payable public nftDistributionAddress;
    event NFTDistribution(uint nftDistributionAmount, address nftDistributionAddress);

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _setTokenURI(tokenId, _tokenURI);
    }

    function distributeNFT() public {
        nftDistributionAmount = nftBalance * nftDistributionPercentage / 100;
        nftDistributionAddress.transfer(nftDistributionAmount);
        emit NFTDistribution(nftDistributionAmount, nftDistributionAddress);
    }

    function internalSetTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _setTokenURI(tokenId, _tokenURI);
    }

    function acquireNFT(string memory name, uint tokenId, uint price) public payable {
        require(treasuryBalance >= price, "Insufficient funds in treasury");
        marketplace.transfer(price);
        _mint(address(this), tokenId);
        _setTokenURI(tokenId, name);
        emit NFTAcquired(tokenId, name);
    }

    function borrowNFT(uint tokenId) public {
        require(_ownerOf(tokenId) == address(this), "NFT not owned by the guild");
        borrowedNFTs[msg.sender].push(tokenId);
        emit NFTBorrowed(tokenId, msg.sender);
    }

    function totalSupply() public view returns (uint) {
        return _tokenCounter.current();
    }

    function distributeProfits(uint profit) public onlyTokenHolders {
        uint totalTokens = totalSupply();
        for (uint i = 0; i < totalTokens; i++) {
            address member = ownerOf(i);
            if (balanceOf(member) > 0) {
                uint amount = profit * balanceOf(member) / totalTokens;
                payable(member).transfer(amount);
            }
        }
    }

    modifier onlyTokenHolders() {
        require(balanceOf(msg.sender) > 0, "Only guild members can perform this action");
        _;
    }
}
