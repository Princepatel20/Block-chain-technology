// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LandRegistry {

  enum UserType {Government, Owner, Buyer, Seller, Inspector}

  struct Land {
    string id;
    address owner; 
    string documentHash;
    uint256 price;
  }

  mapping (string => Land) public lands;

  address public governmentAddress;

  mapping (address => UserType) public users;

  event LandTransferred(string id, address newOwner);

  modifier onlyGovernment() {
    require(msg.sender == governmentAddress, "Not government");
    _;
  }

  modifier onlyInspector() {
    require(users[msg.sender] == UserType.Inspector, "Not inspector");
    _;
  }

  function registerLand(string memory _id, uint256 _price, string memory _documentHash) public onlyGovernment {
    lands[_id] = Land(_id, msg.sender, _documentHash, _price);
  }

  function verifySeller(address _seller) public onlyInspector {
    require(users[_seller] != UserType.Seller, "Seller not verified");
    users[_seller] = UserType.Seller;
  }

  function verifyBuyer(address _buyer) public onlyInspector {
    require(users[_buyer] != UserType.Buyer, "Buyer not verified");
    users[_buyer] = UserType.Buyer;
  }

  function transferLand(string memory _id, address _newOwner) payable public {
    require(msg.value == lands[_id].price, "Incorrect price");
    require(users[msg.sender] == UserType.Seller, "Not authorized"); 
    require(users[_newOwner] == UserType.Buyer, "New owner not verified buyer");

    lands[_id].owner = _newOwner;
    emit LandTransferred(_id, _newOwner);
  }

  function getLandDetails(string memory _id) view public returns(Land memory) {
    return lands[_id];
  }

}
