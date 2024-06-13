// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ABC is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    uint256 public constant MAX_TOKENS = 10000;
    uint256 private constant TOKENS_RESERVED = 5;
    uint256 public price = 0.08 ether;
    uint256 public constant MAX_MINT_PER_TX = 10;

    bool public isSaleActive;
    mapping(address => uint256) private mintedPerWallet;

    string public baseURI;
    string public baseExtension = ".json";

    constructor() ERC721("NFT MYtoky", "MT") Ownable(msg.sender) {
        baseURI = "ipfs://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/";
        _reserveTokens(TOKENS_RESERVED);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _setTokenURI(tokenId, _tokenURI);
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _setTokenURI(tokenId, _tokenURI);
    }

    function mint(uint256 _numTokens) external payable {
        require(isSaleActive, "The sale is paused");
        require(_numTokens > 0 && _numTokens <= MAX_MINT_PER_TX, "Exceeds maximum tokens per transaction");
        require(mintedPerWallet[msg.sender] + _numTokens <= MAX_MINT_PER_TX, "Exceeds maximum tokens per wallet");
        uint256 curTotalSupply = _tokenIdCounter.current();
        require(curTotalSupply + _numTokens <= MAX_TOKENS, "Exceeds maximum tokens available");
        require(_numTokens * price <= msg.value, "Insufficient funds. Please send more ETH");

        for (uint256 i = 0; i < _numTokens; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _safeMint(msg.sender, tokenId);
            setTokenURI(tokenId, string(abi.encodePacked(baseURI, uint2str(tokenId), baseExtension)));
            _tokenIdCounter.increment();
        }

        mintedPerWallet[msg.sender] += _numTokens;
    }

    function _reserveTokens(uint256 _numTokens) private {
        for (uint256 i = 0; i < _numTokens; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _safeMint(owner(), tokenId);
            setTokenURI(tokenId, string(abi.encodePacked(baseURI, uint2str(tokenId), baseExtension)));
            _tokenIdCounter.increment();
        }
    }

    function flipSalesState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    function setBaseURI(string memory _baseUri) external onlyOwner {
        baseURI = _baseUri;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function withdrawAll() external onlyOwner {
        uint256 balance = address(this).balance;
        uint256 balanceOne = (balance * 70) / 100;
        uint256 balanceTwo = balance - balanceOne;
        payable(owner()).transfer(balanceOne);
        payable(owner()).transfer(balanceTwo);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(tokenId < _tokenIdCounter.current(), "Token does not exist");
        return string(abi.encodePacked(baseURI, uint2str(tokenId), baseExtension));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}