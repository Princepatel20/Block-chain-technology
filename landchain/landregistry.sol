// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract LandRegistry {

  enum UserType {Government, Owner, Lawyer, Judge}

  struct Land {
    string id;
    address owner;
    string documentHash;
    uint256 price;
  }

  mapping (string => Land) public lands;

  function registerLand(string memory _id, uint256 _price, string memory _documentHash) public {
    // Only government can register
    require(msg.sender == governmentAddress, "Not authorized");
    
    lands[_id] = Land(_id, msg.sender, _documentHash, _price);
  
  }

  function transferLand(string memory _id, address _newOwner) payable public {

    // Ensure funds were sent
    require(msg.value == lands[_id].price, "Incorrect price");

    // Transfer ownership    
    lands[_id].owner = _newOwner;

  }

  function getLandDetails(string memory _id) view public returns(Land memory) {
      return lands[_id];
  }

  // Government address
  address public governmentAddress;

  // Map user addresses to types
  mapping (address => UserType) public users;

  // Event for land transfer
  event LandTransferred(string id, address newOwner);

}
