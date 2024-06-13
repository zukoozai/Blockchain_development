// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DynamicArtNFT is VRFConsumerBase, ERC721 {
    address payable public vrfCoordinator;
    address public linkToken;
    bytes32 constant private keyHash = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    uint256 public fee;
    uint256 public gasLimit;
    uint256 public requestFee;
    uint256 public totalNFTsMinted;
    string public baseArtwork;
    string[] public traits;
    
    mapping(uint => string[]) public nftTraits;

    event NFTMinted(uint tokenId, string[] traits);

    constructor(
        address payable _vrfCoordinator,
        address _linkToken,
        uint256 _gasLimit,
        uint256 _requestFee
    ) VRFConsumerBase(_vrfCoordinator, _linkToken) ERC721("DynamicArtNFT", "DART") {
        vrfCoordinator = _vrfCoordinator;
        linkToken = _linkToken;
        gasLimit = _gasLimit;
        requestFee = _requestFee;
        fee = 0.1 * 10 ** 18;
    }
    
    function setBaseArtwork(string memory artwork) public {
        baseArtwork = artwork;
    }

    function addTrait(string memory trait) public {
        traits.push(trait);
    }

    function requestRandomTraits() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= requestFee, "Not enough LINK tokens");
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(
        bytes32 requestId,
        uint256 randomness
    ) internal override {
        uint256 tokenId = totalNFTsMinted + 1;
        string[] memory randomTraits = new string[](traits.length);
        
        bytes32[] memory randomWords = new bytes32[](1);
        randomWords[0] = bytes32(randomness);
        
        for (uint i = 0; i < traits.length; i++) {
            uint256 index = uint256(keccak256(abi.encodePacked(randomWords[0], i))) % traits.length;
            randomTraits[i] = traits[index];
        }
        
        nftTraits[tokenId] = randomTraits;
        _mint(msg.sender, tokenId);
        totalNFTsMinted++;
        emit NFTMinted(tokenId, randomTraits);
    }

    function getNFTTraits(uint tokenId) public view returns(string[] memory) {
        return nftTraits[tokenId];
    }
    
}