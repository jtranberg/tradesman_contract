// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TradesmanContract {
    address public tradesman;
    address public client;

    string public tradesmanName;
    string public clientName;
    uint256 public amount;
    uint256 public startDate;
    uint256 public completionDate;

    bool public dutiesCompleted;
    bool public paymentProcessed;

    event DutiesCompleted();
    event PaymentProcessed(address indexed payer, uint256 amount);

    modifier onlyTradesman() {
        require(msg.sender == tradesman, "Caller is not the tradesman");
        _;
    }

    modifier onlyClient() {
        require(msg.sender == client, "Caller is not the client");
        _;
    }

    modifier notPaymentProcessed() {
        require(!paymentProcessed, "Payment already processed");
        _;
    }

    constructor(
        address _tradesman,
        string memory _tradesmanName,
        address _client,
        string memory _clientName,
        uint256 _amount,
        uint256 _startDate,
        uint256 _completionDate
    ) {
        tradesman = _tradesman;
        tradesmanName = _tradesmanName;
        client = _client;
        clientName = _clientName;
        amount = _amount;
        startDate = _startDate;
        completionDate = _completionDate;
    }

    function completeDuties() external onlyTradesman {
        require(!dutiesCompleted, "Duties already completed");
        dutiesCompleted = true;
        emit DutiesCompleted();
    }

    function processPayment() external onlyClient notPaymentProcessed {
        require(dutiesCompleted, "Duties must be completed before processing payment");
        paymentProcessed = true;
        payable(tradesman).transfer(amount);
        emit PaymentProcessed(msg.sender, amount);
    }
}