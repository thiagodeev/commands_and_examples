// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8;

contract Ownable {
  address public owner;

  //creates an event, labels it and sets the return type
  event OwnershipTransferred(address newOwner);

  //executed only once, at the contract deploy
  constructor(){
    owner = msg.sender;
  }

  modifier onlyOwner(){
    require(msg.sender == owner, "You are not the owner!");
    _; //lets the function continue
  }

  function transferOwnership(address payable newOwner) onlyOwner public{
    owner = newOwner;  
    emit OwnershipTransferred(owner); //emits the event passing the variable as a parameter
  }
}