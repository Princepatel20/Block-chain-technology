// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.18;

contract HotelRoom {
    address payable public owner;
    Statuses currentStatus;

    enum Statuses { 
        Vacant, 
        Occupied
    }

    constructor() {
        owner = payable(msg.sender);
        currentStatus = Statuses.Vacant;
    }

   
    function book() payable public onlyWhileVacant costs(2 ether) {
        owner.transfer(msg.value);
        currentStatus = Statuses.Occupied;
        emit Occupy(msg.sender, msg.value);
    }

    modifier onlyWhileVacant {
        require(currentStatus == Statuses.Vacant, "Currently Occupied.");
        _;
    }

    modifier costs(uint _amount){
        require(msg.value >= _amount, "Not Enough Amount Paid.");
        _;
    }

    event Occupy(address _occupant, uint value);
}
