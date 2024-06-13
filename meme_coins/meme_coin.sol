// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Tomcoin is ERC20, Ownable, ERC20Permit {
    uint256 public taxPercentage = 1000;
    mapping(address => bool) public taxExempt;
    uint256 public _totalSupply;

    mapping (address => uint256) public balances;

    event TomcoinMinted(address indexed minter, uint256 amount);
    event TomcoinBurned(address indexed burner, uint256 amount);
    event TomcoinTransferred(address indexed from, address indexed to, uint256 amount);
    event MyOwnershipTransferredEvent(address indexed previousOwner, address indexed newOwner);
   
    constructor(string memory _name, string memory _symbol, address _initialOwner) 
    ERC20(_name, _symbol) 
    Ownable(_initialOwner) 
    ERC20Permit("Tomcoin") 
    {
        _totalSupply = 0;
        _mint(_msgSender(), 1000000000 * 10 * 18);
        setTaxExempt(_msgSender(), true);
        setTaxExempt(address(this), true);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        _totalSupply += amount;
        emit TomcoinMinted(msg.sender, amount);
    }

    function burn(address from, uint256 amount) public onlyOwner {
        require(balances[from] >= amount, "Insufficient balance");
        balances[from] -= amount;
        _totalSupply -= amount;
        emit TomcoinBurned(from, amount);
    }

    function transfer(address to, uint256 value) public override returns(bool) {
        address owner = _msgSender();

        if (taxExempt[_msgSender()] || taxExempt[to]) {
            _transfer(owner, to, value);
            return true;
        }

        uint256 taxAmount = (value * taxPercentage) / 10000;
        _transfer(owner, to, value - taxAmount);

        if (taxAmount > 0) {
            _transfer(owner, address(this), taxAmount);
        }

        return true;
    }

    function setTaxPercentage(uint256 _newTax) external onlyOwner {
        require(_newTax <= 1000, "max 10%");
        taxPercentage = _newTax;
    }

    function setTaxExempt(address forAddress, bool isTaxExempt) public onlyOwner {
        taxExempt[forAddress] = isTaxExempt;
    }

    function withdrawTaxes(uint256 amount) external onlyOwner {
        _transfer(address(this), _msgSender(), amount);
    }

    function transferFrom(address from, address to, uint256 value) public override returns(bool) {
        address owner = from;

        if (taxExempt[from] || taxExempt[to]) {
            _transfer(owner, to, value);
            return true;
        }

        uint256 taxAmount = (value * taxPercentage) / 10000;
        _transfer(owner, to, value - taxAmount);

        if (taxAmount > 0) {
            _transfer(owner, address(this), taxAmount);
        }

        return true;
    }

    function getBalance(address account) public view returns(uint256) {
        return balances[account];
    }

    function getTotalSupply() public view returns(uint256) {
        return _totalSupply;
    }

    function getTaxPercentage() public view returns(uint256) {
        return taxPercentage;
    }
}
