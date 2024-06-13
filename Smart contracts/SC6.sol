// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

contract TradeFinance {
    enum State { CREATED, SHIPPED, COMPLETED, DISPUTED }
    
    struct TradeAgreement {
        address payable importer;
        address payable exporter;
        string productDescription;
        uint amount;
        uint releaseDate;
        State state;
    }

    mapping(uint => TradeAgreement) public agreements;
    uint public agreementCount;

    event AgreementCreated(uint agreementId, address indexed importer, address indexed exporter);
    event ShipmentMarked(uint agreementId);
    event TradeCompleted(uint agreementId);

    function createAgreement(address payable exporter, string memory productDescription, uint amount, uint deliveryDays) public payable {
        require(msg.value == amount, "Incorrect deposit amount");
        address payable importerPayable = payable(msg.sender);
        uint agreementId = agreementCount++;
        agreements[agreementId] = TradeAgreement(importerPayable, exporter, productDescription, amount, block.timestamp + daysToSeconds(deliveryDays), State.CREATED);
        emit AgreementCreated(agreementId, importerPayable, exporter);
    }

    function markShipment(uint agreementId) public {
        TradeAgreement storage agreement = agreements[agreementId];
        require(agreement.importer == msg.sender, "Only importer can mark shipment");
        require(agreement.state == State.CREATED, "Agreement not in correct state to mark shipment");
        agreement.state = State.SHIPPED;
        emit ShipmentMarked(agreementId);
    }

    function releasePayment(uint agreementId) public {
        TradeAgreement storage agreement = agreements[agreementId];
        require(block.timestamp >= agreement.releaseDate, "Payment release date not reached yet");
        require(agreement.state == State.SHIPPED, "Shipment not yet marked");
        require(address(this).balance >= agreement.amount, "Insufficient contract balance");
        (bool success, ) = agreement.exporter.call{value: agreement.amount}("");
        require(success, "Payment transfer failed");
        
        agreement.state = State.COMPLETED;
        emit TradeCompleted(agreementId);
    }

    function daysToSeconds(uint _days) private pure returns (uint) {
        return _days * 1 days;
    }
}
