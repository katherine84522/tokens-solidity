pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply = 0;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    event Transfer(address from, address to, uint value);
    event Approval(address owner, address spender, uint value);

    constructor(string name_, string symbol_) {

        name = name_;
        symbol = symbol_;
    }

    function name() public returns(string){

        return name;
    }

    function symbol() public returns(string){

        return symbol;
    }

    function decimals() public returns (uint8){

        return decimals;
    }

    function totalSupply() public returns(uint256){

        return totalSupply;
    }

    function balanceOf(address account) public returns(uint256){

        return balances[account];

    }

    function transfer(address payable to, uint256 value) external returns(bool){

        require( to != address(0));
        require( balances[msg.sender] >= value);

        emit Transfer(msg.sender, to, value);
        balances[to] += value;
        balances[msg.sender] -= value;
    }

    function allowance(address owner, address spender) external returns(bool){

        uint256 allowance = 0;

        if(allowances[owner][spender] > 0){
            allowance = allowances[owner][spender];
        }

        return allowance;
    }

    function approve(address spender, uint256 value) external returns(bool){

        require( spender != address(0));

        allowances[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns(bool){

        require( from != address(0));
        require( to != address(0));
        require( allowances[from][to] >= value);

        emit Approval( from, to, value);

        uint256 newValue = allowances[from][to] - value;
        allowances[from][to] = newValue;

        balances[from] -= value;
        balances[to] += value;

        return true;
    }

}