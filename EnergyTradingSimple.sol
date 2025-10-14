// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EnergyTrading {
    
    // Owner
    address public owner;
    bool public paused = false;
    
    // Structs
    struct EnergyListing {
        uint256 id;
        address producer;
        uint256 amount;
        uint256 pricePerKWh;
        bool active;
        uint256 timestamp;
    }
    
    struct Transaction {
        uint256 listingId;
        address producer;
        address consumer;
        uint256 amount;
        uint256 pricePerKWh;
        uint256 totalCost;
        uint256 timestamp;
        string transactionType;
    }
    
    // State variables
    mapping(address => uint256) public energyBalances;
    mapping(address => uint256) public pendingWithdrawals;
    mapping(address => Transaction[]) public transactionHistory;
    
    EnergyListing[] public listings;
    uint256 public nextListingId = 1;
    
    // Events
    event EnergyListed(uint256 indexed listingId, address indexed producer, uint256 amount, uint256 pricePerKWh, uint256 timestamp);
    event EnergyPurchased(uint256 indexed listingId, address indexed producer, address indexed consumer, uint256 amount, uint256 totalCost, uint256 timestamp);
    event FundsWithdrawn(address indexed producer, uint256 amount, uint256 timestamp);
    event UserRegistered(address indexed user, string userType, uint256 timestamp);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }
    
    modifier validAmount(uint256 amount) {
        require(amount > 0, "Amount must be greater than 0");
        _;
    }
    
    modifier listingExists(uint256 listingId) {
        require(listingId > 0 && listingId < nextListingId, "Invalid listing ID");
        require(listings[listingId - 1].active, "Listing is not active");
        _;
    }
    
    // Constructor
    constructor() {
        owner = msg.sender;
        energyBalances[msg.sender] = 1000 * 1e18; // 1000 kWh for testing
    }
    
    // Registration functions
    function registerAsProducer() external whenNotPaused {
        if (energyBalances[msg.sender] == 0) {
            energyBalances[msg.sender] = 100 * 1e18; // 100 kWh
        }
        emit UserRegistered(msg.sender, "PRODUCER", block.timestamp);
    }
    
    function registerAsConsumer() external whenNotPaused {
        emit UserRegistered(msg.sender, "CONSUMER", block.timestamp);
    }
    
    // Core functions
    function sellEnergy(uint256 amount, uint256 pricePerKWh) external whenNotPaused validAmount(amount) {
        require(pricePerKWh > 0, "Price must be greater than 0");
        require(energyBalances[msg.sender] >= amount, "Insufficient energy balance");
        
        energyBalances[msg.sender] -= amount;
        
        EnergyListing memory newListing = EnergyListing({
            id: nextListingId,
            producer: msg.sender,
            amount: amount,
            pricePerKWh: pricePerKWh,
            active: true,
            timestamp: block.timestamp
        });
        
        listings.push(newListing);
        
        Transaction memory sellTransaction = Transaction({
            listingId: nextListingId,
            producer: msg.sender,
            consumer: address(0),
            amount: amount,
            pricePerKWh: pricePerKWh,
            totalCost: 0,
            timestamp: block.timestamp,
            transactionType: "SELL"
        });
        
        transactionHistory[msg.sender].push(sellTransaction);
        
        emit EnergyListed(nextListingId, msg.sender, amount, pricePerKWh, block.timestamp);
        
        nextListingId++;
    }
    
    function buyEnergy(uint256 listingId) external payable whenNotPaused listingExists(listingId) {
        EnergyListing storage listing = listings[listingId - 1];
        require(listing.producer != msg.sender, "Cannot buy your own energy");
        
        uint256 totalCost = listing.amount * listing.pricePerKWh / 1e18;
        require(msg.value >= totalCost, "Insufficient payment");
        
        listing.active = false;
        energyBalances[msg.sender] += listing.amount;
        pendingWithdrawals[listing.producer] += totalCost;
        
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
        
        Transaction memory buyTransaction = Transaction({
            listingId: listingId,
            producer: listing.producer,
            consumer: msg.sender,
            amount: listing.amount,
            pricePerKWh: listing.pricePerKWh,
            totalCost: totalCost,
            timestamp: block.timestamp,
            transactionType: "BUY"
        });
        
        transactionHistory[msg.sender].push(buyTransaction);
        transactionHistory[listing.producer].push(buyTransaction);
        
        emit EnergyPurchased(listingId, listing.producer, msg.sender, listing.amount, totalCost, block.timestamp);
    }
    
    function withdrawFunds() external {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No funds to withdraw");
        
        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        
        emit FundsWithdrawn(msg.sender, amount, block.timestamp);
    }
    
    // View functions
    function getEnergyBalance(address user) external view returns (uint256) {
        return energyBalances[user];
    }
    
    function getPendingWithdrawals(address user) external view returns (uint256) {
        return pendingWithdrawals[user];
    }
    
    function getListings() external view returns (EnergyListing[] memory) {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < listings.length; i++) {
            if (listings[i].active) {
                activeCount++;
            }
        }
        
        EnergyListing[] memory activeListings = new EnergyListing[](activeCount);
        uint256 index = 0;
        
        for (uint256 i = 0; i < listings.length; i++) {
            if (listings[i].active) {
                activeListings[index] = listings[i];
                index++;
            }
        }
        
        return activeListings;
    }
    
    function getUserListings(address user) external view returns (EnergyListing[] memory) {
        uint256 userActiveCount = 0;
        for (uint256 i = 0; i < listings.length; i++) {
            if (listings[i].active && listings[i].producer == user) {
                userActiveCount++;
            }
        }
        
        EnergyListing[] memory userActiveListings = new EnergyListing[](userActiveCount);
        uint256 index = 0;
        
        for (uint256 i = 0; i < listings.length; i++) {
            if (listings[i].active && listings[i].producer == user) {
                userActiveListings[index] = listings[i];
                index++;
            }
        }
        
        return userActiveListings;
    }
    
    function getTransactionHistory(address user) external view returns (Transaction[] memory) {
        return transactionHistory[user];
    }
    
    function getAllListings() external view returns (EnergyListing[] memory) {
        return listings;
    }
    
    // Admin functions
    function togglePause() external onlyOwner {
        paused = !paused;
    }
    
    function isPaused() external view returns (bool) {
        return paused;
    }
    
    function emergencyWithdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
    
    function addEnergyTokens(address user, uint256 amount) external onlyOwner {
        energyBalances[user] += amount;
    }
    
    receive() external payable {}
}
