// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

contract lottery {
    address public owner;
    address payable[] public participants;
    bool public isLotteryOpen;
    uint public startTime;

    constructor() {
        owner = msg.sender;
        isLotteryOpen = false;  
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this function");
        _;
    }

    // Function for participants to add them to the lottery
    function takePart() public payable {
        require(msg.value >= 1 ether, "Not enough ether");
        require(isLotteryOpen, "Lottery is not open");
        participants.push(payable(msg.sender));
    }

    // Function to start the lottery
    function start() public onlyOwner {
        require(startTime > 0, "Start time not set");
        require(block.timestamp >= startTime, "Lottery cannot start yet");
        isLotteryOpen = true;  // Opens the lottery for participation
    }

    // Setter function to manually set the start time
    function setStartTime(uint _startTime) public onlyOwner {
        require(_startTime > block.timestamp, "Start time must be in the future");
        startTime = _startTime;
    }




    // function to end lottery
    function end() public onlyOwner{
        isLotteryOpen=false;

    }



function pickWinner() public onlyOwner returns (address) {
    require(!isLotteryOpen, "Lottery is still open");
    require(participants.length > 0, "No participants");

    // Generate a random index from the participants array
    uint randomIndex = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length))) % participants.length;

    // Return the winner's address
    return participants[randomIndex];
}

    // function for send ammount to winner

function sendAmount(address winner) public onlyOwner{
    require(isLotteryOpen==false,"lottery is closed");
    require(winner != address(0), "Invalid winner address");
     payable(winner).transfer(address(this).balance);
       delete participants;  // restart winner

}





}