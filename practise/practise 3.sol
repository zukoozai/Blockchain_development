// SPDX-License-Identifier: MIT



pragma solidity ^0.8.25;



contract Auction {
    address public highestBidder;
    uint256 public highestBid;
    mapping(address => uint256) public bids;
    bool public ended;
    event HighestBidIncrease(address bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    constructor() {
        highestBidder = msg.sender;
        highestBid = 0;
        ended = false;
    }

    function bid() external payable {
        require(!ended, "Auction ended");
        require(msg.value > highestBid, "Bid not high enough");

        if (highestBid != 0) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit HighestBidIncrease(msg.sender, msg.value);
    }

    function endAuction() external {
        require(!ended, "Auction already ended");
        require(msg.sender == highestBidder, "You are not the highest bidder");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        payable(highestBidder).transfer(highestBid);
    }
}
