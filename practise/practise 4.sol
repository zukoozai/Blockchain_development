// SPDX-License-Identifier: MIT




pragma solidity ^0.8.25;


    contract DEX {
        mapping(address => mapping(address => uint256)) public balance;

        event Deposit(address indexed from, address indexed token, uint256 amount);
        event Withdrawal(address indexed to, address indexed token, uint256 amount);
        event Trade(address indexed trader, address indexed tokenGive, uint256 amountGive, address indexed tokenGet, uint256 amountGet);

        function deposit(address _token, uint256 _amount) external {
            require(_amount > 0, "Invalid amount");
            balance[msg.sender][_token] += _amount;
            emit Deposit(msg.sender, _token, _amount);
        }

        function withdraw(address _token, uint256 _amount) external {
            require(_amount > 0, "Invalid amount");
            require(balance[msg.sender][_token] >= _amount, "Insufficient balance");
            balance[msg.sender][_token] -= _amount;
            emit Withdrawal(msg.sender, _token, _amount);
        }

        function trade(address _tokenGive, uint256 _amountGive, address _tokenGet, uint256 _amountGet) external {
          require(_amountGive > 0 && _amountGet > 0, "Invalid trade");
          require(balance[msg.sender][_tokenGive] >= _amountGive, "Insufficient balance");

          balances[msg.sender][_tokenGive] -= _amountGive;
          balances[msg.sender][_tokenGet] += _amountGet;

          emit Trade(msg.sender, _tokenGive, _amountGive, _tokenGet, _amountGet);
        }
    }