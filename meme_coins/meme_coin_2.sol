
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MemeCoin {
    
    mapping(address => uint256) public balances;
    mapping(address => uint256) public totalCoins;
    mapping(address => uint256) public mintedCoins;

    uint256 public totalSupply;
    address public owner;

    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
        totalSupply = 1000000;
        balances[owner] = totalSupply;
        totalCoins[owner] = totalSupply;
        mintedCoins[owner] = 0;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only the owner can mint the coins");
        require(amount > 0, "Amount must be greater than 0");
        require(totalCoins[msg.sender] + amount <=totalSupply, "Not enough coins to mint");

        balances[to] += amount;
        totalCoins[owner] += amount;
        mintedCoins[owner] += amount;
    }

    function burn(address from, uint256 amount) public {
        require(msg.sender == owner, "Only the owner can burn coins");
        require(amount > 0, "Amount must be greater than 0");
        require(balances[from] >= amount, "Not enough coins to burn");

        balances[from] -= amount;
        totalCoins[owner] -= amount;
        mintedCoins[owner] -= amount;
    }

    function transfer(address to, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Not enough coins to transfer");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Only the owner can transfer ownership");
        require(newOwner != address(0), "New owner cannot be the zero address");

        address previousOwner = owner;
        owner = newOwner;

        emit OwnershipTransferred(previousOwner, newOwner);
    }

    function getTotalSupply() public view returns(uint256) {
        return totalSupply;
    }

    function getBalance(address user) public view returns(uint256) {
        return balances[user];
    }

    function getMintedCoins(address user) public view returns(uint256) {
        return mintedCoins[user];
    }

}