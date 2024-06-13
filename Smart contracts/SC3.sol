// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract HouseEscrow {
    address payable public buyer;
    address payable public seller;
    uint public purchasePrice;
    bool public fundsReleased;

    function setBuyer(address payable _buyer) public {
        buyer = _buyer;
    }

    function setSeller(address payable _seller) public {
        seller = _seller;
    }

    function setPurchasePrice(uint _purchasePrice) public {
        purchasePrice = _purchasePrice;
    }

    function depositFunds() public payable {
        require(msg.value == purchasePrice, "Deposit must match purchase price");
        fundsReleased = false;
    }

    function releaseFunds(address payable _newOwner) public {
        require(msg.sender == seller, "Only seller can call this function");
        require(!fundsReleased, "Funds already released");
        require(_newOwner == buyer, "Ownership must be transferred to buyer");
        seller.transfer(address(this).balance);
        fundsReleased = true;
    }
}