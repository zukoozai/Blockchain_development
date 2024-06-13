// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EvenTicket is ERC721 {
    using Counters for Counters.Counter;
    
    struct Event {
        string name;
        uint startTime;
        uint price;
    }

    mapping(uint => Counters.Counter) private _ticketCounters;
    mapping(uint => Event) public events;

    event TicketMinted(uint eventId, uint tokenId, address owner);

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function createEvent(string memory name, uint startTime, uint price, uint eventId, address to) public payable {
        require(events[eventId].price == msg.value, "Incorrect payment amount");
        require(block.timestamp < startTime, "Event has already started");
        uint tokenId = _ticketCounters[eventId].current();
        _mint(to, tokenId);
        emit TicketMinted(eventId, tokenId, to);
    }

    function verifyTicket(uint eventId, uint tokenId, address owner) public view returns(bool) {
        return ownerOf(tokenId) == owner && events[eventId].startTime > block.timestamp;
    }
}