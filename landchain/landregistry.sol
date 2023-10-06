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

  struct LandDetails {
    string area;
    string location;
    string surveyNo;
    string landaddress;
    uint256 price;
    string mapIPFSHash;
  }

  mapping(string => Land) public lands;
  mapping(string => LandDetails) public landDetails;

  address public governmentAddress;

  mapping(address => UserType) public users;
  
  event LandTransferred(string id, address newOwner);
  event LandDetailsAdded(string landId, LandDetails details);

  modifier onlyGovernment() {
    require(msg.sender == governmentAddress, "Not government");
    _;
  }

  modifier onlyInspector() {
    require(users[msg.sender] == UserType.Inspector, "Not inspector");
    _;
  }

  // Government and inspector functions

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

  // Buyer and seller functions

  function addLandDetails(string memory landId, LandDetails memory details) public {
    landDetails[landId] = details;
    emit LandDetailsAdded(landId, details);
  }

  function transferLand(string memory _id, address _newOwner) payable public {
    require(msg.value == lands[_id].price, "Incorrect price");
    require(users[msg.sender] == UserType.Seller, "Not authorized");
    require(users[_newOwner] == UserType.Buyer, "Not verified buyer");

    lands[_id].owner = _newOwner;

    emit LandTransferred(_id, _newOwner);
  }

  // Shared functions

  function getLand(string memory _id) view public returns (Land memory) {
    return lands[_id]; 
  }

  function getLandDetails(string memory landId) view public returns (LandDetails memory) {
    return landDetails[landId];
  }

}
