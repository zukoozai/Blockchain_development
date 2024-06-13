// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract RenewableEnergy {

    mapping(address => uint) public residentEnergy;
    uint public pricePerUnit;
    address payable public utilityCompany;

    event EnergyGenerated(address indexed resident, uint amount);
    event PaymentMade(address indexed resident, uint amount);


    function setInitialValues(uint _initialPrice, address payable _company) public {
        require(pricePerUnit == 0, "Initial values already set");
        pricePerUnit = _initialPrice;
        utilityCompany = _company;
    }

    function depositFunds() public payable {
        require(msg.sender == utilityCompany, "Only utility company can deposit funds");
    }

    function withdrawPayment() public {
        uint amount = residentEnergy[msg.sender] * pricePerUnit;
        require(amount > 0, "No earned payments to withdraw");
        residentEnergy[msg.sender] = 0;
        utilityCompany.transfer(amount);
        emit PaymentMade(msg.sender, amount);
    }
}