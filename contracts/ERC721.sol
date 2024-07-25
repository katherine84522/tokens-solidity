pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ERC721 {


    mapping(address => uint256[]) balances;
    mapping(uint256 => address) tokenOwners;
    mapping(address => mapping(uint256 => address)) approvals; //uint256 is tokenID
    mapping(address => mapping(address => bool)) operators;
    uint256 tokenAmount;


    constructor(string name_, string symbol_) {

        name = name_;
        symbol = symbol_;
    }

    function balanceOf(address owner) public view returns(uint){

        return balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns(address){

        require(tokenOwners[tokenId]);

        return tokenOwners[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId, bytes data) public {

        require( from != address(0));
        require( to != address(0));
        require( tokenOwners[tokenId] == from);

        if( msg.sender != from){       
            require(approvals[from][msg.sender] == tokenId);
            delete approvals[from][msg.sender]; //remove approval before transanction to prevent reentrancy attack
        }

        emit Transfer(from, to, tokenId);

        uint256[] _tokens = balances[from];

        for( uint256 i = 0; i< _tokens.length; i++){

            if( _tokens[i] == tokenId){
                _tokens = _tokens[_tokens.length-1];
                _tokens.pop();
                break; 
            }
        }
        balances[from] = _tokens; // _tokens is an array without tokenId
        balances[to].push(tokenId);
        tokenOwners[tokenId] = to;

    }

    function approve(address to, uint256 tokenId) public {

        if(msg.sender != tokenOwners[tokenId]){

            address _owner = tokenOwners[tokenId];
            require( operators[_owner][msg.sender]);
        }

        approvals[msg.sender][tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public {

        require(operator != address(0));

        operators[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);

    }

    function getApproved(uint256 tokenId) public returns(address){

        required(tokenId <= totalAmount);

        address _owner = tokenOwners[tokenId];

        return approvals[_owner][tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view returns(bool) {

        return operators[owner][operator];
    }
   
}