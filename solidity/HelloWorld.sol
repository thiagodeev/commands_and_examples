// SPDX-License-Identifier: GPL-3.0-or-later
//this line above describes the Smart Contract license

pragma solidity ^0.8;  //solidity version

import "./Ownable.sol";

//the SafeMath library is no longer needed to 0.8 Solidity version onwards due the variables no longer overflow/underflow 
library SafeMath {
  //pure Functions: does not change or query any value on Blockchain, it's free of fees
  function sum(uint a, uint b) internal pure returns(uint) {
    uint c = a + b;
    require(c >= a, "Sum Overflow!");

    return c;
  }

  function sub(uint a, uint b) internal pure returns(uint) {
    require(b <= a, "Sub Underflow!");
    uint c = a - b;

    return c;
  }

  function mul(uint a, uint b) internal pure returns(uint) {
    if(a == 0){
      return 0;
    }

    uint c = a * b;
    require(c / a == b, "Mul Overflow");

    return c;
  }

  function div(uint a, uint b) internal pure returns(uint) {
    uint c = a / b;
    
    return c;
  }
}

contract HelloWorld is Ownable{
  using SafeMath for uint;

  //declares a string variable
  string public text;
  //declares an integer variable
  uint public number;
  //declares a variable that will store a wallet address
  address payable public userAddress;
  //declares an boolean variable
  bool public answer;

  //structs is like a cheap Objects version
  struct Interaction {
    uint timestamp;
    string typeOfInteraction;
  }

  struct User {
    uint balances;
    uint numOfInteractions;
    mapping (uint => Interaction) interaction;
  }
  //declares a Mapping (map each address to an User(the struct))
  mapping (address => User) public user;

  //"memory": declares that the value of myText variable will exist only in hardware memory, not in the Blockchain
  //"onlyOwner": declares that the function will only be executed if the condition of onlyOwner modifier has been satisfied
  function setText(string memory myText) onlyOwner public {
    text = myText;
    setInteracted("setText");
  }

  //"payable": declares a payable function, which means that receives money.
  function setNumber (uint myNumber) public payable {
    require(msg.value >= 1, "Insufficient ETH sent.");//msg.value is the money sent

    user[msg.sender].balances = user[msg.sender].balances.sum(msg.value); //msg.sender is the currently interacting user wallet address. 

    number = myNumber;
    setInteracted("setNumber");
  }

  //Public Functions: visible to users
  function setUserAddress() public {
    userAddress = payable(msg.sender);
    setInteracted("setUserAddress");
  }

  function setAnswer(bool trueOrFalse) public {
    answer = trueOrFalse;
    setInteracted("setAnswer");
  }

  //Private Functions: not visible and changeable for users or derivative contracts, only for the Contract itself
  function setInteracted(string memory typeOfInteraction) private {
    Interaction memory interaction = Interaction(block.timestamp, typeOfInteraction);
    user[msg.sender].interaction[user[msg.sender].numOfInteractions] = interaction;

    user[msg.sender].numOfInteractions = user[msg.sender].numOfInteractions.sum(1);
  }

  function getInteraction(uint interactionIndex) view public returns(uint timeStamp, string memory typeOfInteraction){
    return (
      user[msg.sender].interaction[interactionIndex].timestamp, 
      user[msg.sender].interaction[interactionIndex].typeOfInteraction
    );
  }

  function sendETH(address payable targetAddress) public payable{
    setInteracted("sendETH");

    targetAddress.transfer(msg.value);
  }

  function withdraw() public {
    require(user[msg.sender].balances > 0, "Insufficient funds.");

    uint amount = user[msg.sender].balances;
    user[msg.sender].balances = 0;
    setInteracted("withdraw");

    payable(msg.sender).transfer(amount);
  }

  //view Functions: can consult values on Blockchain, but not change
  function sumStored(uint a) public view returns(uint) {
    return a.sum(number);
  }
}