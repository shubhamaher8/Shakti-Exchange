# Shakti Exchange - Architecture Overview

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                            USER LAYER                                │
│                                                                       │
│  ┌──────────────────┐                     ┌──────────────────┐      │
│  │  Energy Producer │                     │  Energy Consumer │      │
│  │  (Solar Panel    │                     │  (Household/     │      │
│  │   Owner)         │                     │   Business)      │      │
│  └────────┬─────────┘                     └────────┬─────────┘      │
│           │                                        │                 │
│           └──────────────────┬─────────────────────┘                │
│                              │                                       │
└──────────────────────────────┼───────────────────────────────────────┘
                               │
                               │ Browser Access
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      FRONTEND APPLICATION                            │
│                                                                       │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │                    Landing Page (index.html)                │    │
│  │  • Hero Section      • Features      • How It Works         │    │
│  │  • FAQ               • Contact                              │    │
│  └────────────────────────────────────────────────────────────┘    │
│                               │                                      │
│                               │ Navigation                           │
│                               ▼                                      │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │              Dashboard (dashboard.html)                     │    │
│  │                                                              │    │
│  │  ┌──────────┬──────────┬──────────┬──────────┬──────────┐ │    │
│  │  │ Register │Marketplace│   Sell   │My Sales  │ History  │ │    │
│  │  └──────────┴──────────┴──────────┴──────────┴──────────┘ │    │
│  │                                                              │    │
│  │  • User Registration       • Energy Listings                │    │
│  │  • Buy/Sell Interface      • Transaction History            │    │
│  │  • Wallet Status           • Balance Management             │    │
│  └────────────────────────────────────────────────────────────┘    │
│                               │                                      │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │            Application Logic (app.js)                       │    │
│  │                                                              │    │
│  │  • Wallet Connection       • Smart Contract Interaction     │    │
│  │  • Event Handlers          • Data Formatting                │    │
│  │  • UI State Management     • Error Handling                 │    │
│  └────────────────────────────────────────────────────────────┘    │
└───────────────────────────────┼─────────────────────────────────────┘
                                │
                                │ Web3.js / Ethers.js
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       WALLET LAYER (MetaMask)                        │
│                                                                       │
│  • Private Key Management                                            │
│  • Transaction Signing                                               │
│  • Network Connection                                                │
│  • Account Management                                                │
└───────────────────────────────┼─────────────────────────────────────┘
                                │
                                │ JSON-RPC / HTTPS
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   BLOCKCHAIN LAYER (Ethereum)                        │
│                                                                       │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │              Sepolia Testnet (Chain ID: 11155111)           │    │
│  └────────────────────────────────────────────────────────────┘    │
│                               │                                      │
│                               ▼                                      │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │         EnergyTrading Smart Contract (Solidity)             │    │
│  │         Address: 0x501B9b7d87dA4a291E78095EF6493950...     │    │
│  │                                                              │    │
│  │  STATE STORAGE:                                             │    │
│  │  ┌──────────────────────────────────────────────────────┐ │    │
│  │  │ • energyBalances[address]      → uint256            │ │    │
│  │  │ • pendingWithdrawals[address]  → uint256            │ │    │
│  │  │ • listings[]                   → EnergyListing[]    │ │    │
│  │  │ • transactionHistory[address]  → Transaction[]      │ │    │
│  │  │ • owner                        → address            │ │    │
│  │  │ • paused                       → bool               │ │    │
│  │  └──────────────────────────────────────────────────────┘ │    │
│  │                                                              │    │
│  │  FUNCTIONS:                                                 │    │
│  │  ┌──────────────────────────────────────────────────────┐ │    │
│  │  │ Registration:                                         │ │    │
│  │  │  • registerAsProducer()                              │ │    │
│  │  │  • registerAsConsumer()                              │ │    │
│  │  │                                                       │ │    │
│  │  │ Trading:                                              │ │    │
│  │  │  • sellEnergy(amount, pricePerKWh)                   │ │    │
│  │  │  • buyEnergy(listingId) payable                      │ │    │
│  │  │  • withdrawFunds()                                   │ │    │
│  │  │                                                       │ │    │
│  │  │ View Functions:                                       │ │    │
│  │  │  • getListings()                                     │ │    │
│  │  │  • getUserListings(address)                          │ │    │
│  │  │  • getTransactionHistory(address)                    │ │    │
│  │  │  • getEnergyBalance(address)                         │ │    │
│  │  │  • getPendingWithdrawals(address)                    │ │    │
│  │  │                                                       │ │    │
│  │  │ Admin Functions:                                      │ │    │
│  │  │  • togglePause()                                     │ │    │
│  │  │  • emergencyWithdraw()                               │ │    │
│  │  │  • addEnergyTokens(address, amount)                  │ │    │
│  │  └──────────────────────────────────────────────────────┘ │    │
│  │                                                              │    │
│  │  EVENTS:                                                    │    │
│  │  • EnergyListed(listingId, producer, amount, price, time)  │    │
│  │  • EnergyPurchased(listingId, producer, consumer, ...)     │    │
│  │  • FundsWithdrawn(producer, amount, timestamp)             │    │
│  │  • UserRegistered(user, userType, timestamp)               │    │
│  └────────────────────────────────────────────────────────────┘    │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

## Data Flow Diagrams

### 1. User Registration Flow

```
User                    Frontend              Smart Contract         Blockchain
 │                         │                        │                    │
 │──Open Dashboard────────→│                        │                    │
 │                         │                        │                    │
 │──Click Register Tab────→│                        │                    │
 │                         │                        │                    │
 │──Enter Name & Type─────→│                        │                    │
 │                         │                        │                    │
 │──Click Register Now────→│                        │                    │
 │                         │                        │                    │
 │                         │──Prompt MetaMask───→(MetaMask Popup)       │
 │                         │                        │                    │
 │←──Approve Transaction──←│                        │                    │
 │                         │                        │                    │
 │                         │──registerAsProducer()─→│                    │
 │                         │   OR                   │                    │
 │                         │──registerAsConsumer()─→│                    │
 │                         │                        │                    │
 │                         │                        │──Write State──────→│
 │                         │                        │  (Add user)        │
 │                         │                        │                    │
 │                         │                        │←──Confirmation────←│
 │                         │                        │                    │
 │                         │                        │──Emit Event────────→│
 │                         │                        │  UserRegistered    │
 │                         │                        │                    │
 │                         │←──Transaction Hash────←│                    │
 │                         │                        │                    │
 │←──Success Message──────←│                        │                    │
 │  "Registered! +100kWh"  │                        │                    │
 │                         │                        │                    │
```

### 2. Sell Energy Flow

```
Producer                Frontend              Smart Contract         Blockchain
 │                         │                        │                    │
 │──Go to Sell Tab────────→│                        │                    │
 │                         │                        │                    │
 │──Enter Amount: 5 kWh───→│                        │                    │
 │──Enter Price: 0.0001───→│                        │                    │
 │                         │                        │                    │
 │                         │──Calculate Total───────│                    │
 │                         │  (5 × 0.0001 = 0.0005 ETH)                 │
 │                         │                        │                    │
 │──Click Sell Energy─────→│                        │                    │
 │                         │                        │                    │
 │                         │──Prompt MetaMask───→(MetaMask)             │
 │                         │                        │                    │
 │←──Approve Transaction──←│                        │                    │
 │                         │                        │                    │
 │                         │──sellEnergy(──────────→│                    │
 │                         │    5 kWh,              │                    │
 │                         │    0.0001 ETH/kWh)     │                    │
 │                         │                        │                    │
 │                         │                        │──Check Balance────→│
 │                         │                        │  (balance ≥ 5?)   │
 │                         │                        │                    │
 │                         │                        │──Deduct Energy────→│
 │                         │                        │  (100 → 95 kWh)   │
 │                         │                        │                    │
 │                         │                        │──Create Listing───→│
 │                         │                        │  {id: 1,          │
 │                         │                        │   producer: 0x.., │
 │                         │                        │   amount: 5,      │
 │                         │                        │   price: 0.0001,  │
 │                         │                        │   active: true}   │
 │                         │                        │                    │
 │                         │                        │──Save Transaction─→│
 │                         │                        │  to history       │
 │                         │                        │                    │
 │                         │                        │←──Confirmation────←│
 │                         │                        │                    │
 │                         │                        │──Emit Event────────→│
 │                         │                        │  EnergyListed     │
 │                         │                        │                    │
 │                         │←──Transaction Hash────←│                    │
 │                         │                        │                    │
 │                         │──Refresh Listings──────│                    │
 │                         │                        │                    │
 │←──Success & Updated────←│                        │                    │
 │  Balance (95 kWh)       │                        │                    │
 │                         │                        │                    │
```

### 3. Buy Energy Flow

```
Consumer                Frontend              Smart Contract         Blockchain
 │                         │                        │                    │
 │──Go to Marketplace─────→│                        │                    │
 │                         │                        │                    │
 │                         │──getListings()────────→│                    │
 │                         │                        │                    │
 │                         │                        │──Read State───────→│
 │                         │                        │  (active listings)│
 │                         │                        │                    │
 │                         │←──Return Listings─────←│                    │
 │                         │                        │                    │
 │←──Display Cards────────←│                        │                    │
 │  [Listing 1: 5kWh]      │                        │                    │
 │  [Listing 2: 10kWh]     │                        │                    │
 │                         │                        │                    │
 │──Select Listing 1──────→│                        │                    │
 │──Click Purchase────────→│                        │                    │
 │                         │                        │                    │
 │                         │──Calculate Cost────────│                    │
 │                         │  (5 × 0.0001 = 0.0005 ETH)                 │
 │                         │                        │                    │
 │                         │──Prompt MetaMask───→(MetaMask)             │
 │                         │  "Send 0.0005 ETH"     │                    │
 │                         │                        │                    │
 │←──Review & Approve─────←│                        │                    │
 │                         │                        │                    │
 │                         │──buyEnergy(1) {───────→│                    │
 │                         │    value: 0.0005 ETH   │                    │
 │                         │  }                     │                    │
 │                         │                        │                    │
 │                         │                        │──Validate Listing─→│
 │                         │                        │  (exists? active?)│
 │                         │                        │                    │
 │                         │                        │──Check Payment────→│
 │                         │                        │  (≥ 0.0005 ETH?)  │
 │                         │                        │                    │
 │                         │                        │──Mark Inactive────→│
 │                         │                        │  listing.active=F │
 │                         │                        │                    │
 │                         │                        │──Add Energy───────→│
 │                         │                        │  consumer: +5 kWh │
 │                         │                        │                    │
 │                         │                        │──Add to Escrow────→│
 │                         │                        │  producer pending:│
 │                         │                        │  +0.0005 ETH      │
 │                         │                        │                    │
 │                         │                        │──Save Transactions→│
 │                         │                        │  (for both users) │
 │                         │                        │                    │
 │                         │                        │←──Confirmation────←│
 │                         │                        │                    │
 │                         │                        │──Emit Event────────→│
 │                         │                        │  EnergyPurchased  │
 │                         │                        │                    │
 │                         │←──Transaction Hash────←│                    │
 │                         │                        │                    │
 │                         │──Update Balances───────│                    │
 │                         │                        │                    │
 │←──Success Message──────←│                        │                    │
 │  "Purchased 5 kWh!"     │                        │                    │
 │  Energy Balance: 5 kWh  │                        │                    │
 │                         │                        │                    │
```

### 4. Withdraw Funds Flow

```
Producer                Frontend              Smart Contract         Blockchain
 │                         │                        │                    │
 │──View Wallet Status────→│                        │                    │
 │                         │                        │                    │
 │                         │──getPendingWithdrawals→│                    │
 │                         │                        │                    │
 │                         │                        │──Read State───────→│
 │                         │                        │                    │
 │                         │←──Return Amount────────│                    │
 │                         │  (0.0005 ETH)          │                    │
 │                         │                        │                    │
 │←──Display Pending──────←│                        │                    │
 │  "Pending: 0.0005 ETH"  │                        │                    │
 │  [Withdraw Funds]       │                        │                    │
 │                         │                        │                    │
 │──Click Withdraw────────→│                        │                    │
 │                         │                        │                    │
 │                         │──Prompt MetaMask───→(MetaMask)             │
 │                         │  (Gas fee only)        │                    │
 │                         │                        │                    │
 │←──Approve Transaction──←│                        │                    │
 │                         │                        │                    │
 │                         │──withdrawFunds()──────→│                    │
 │                         │                        │                    │
 │                         │                        │──Check Amount─────→│
 │                         │                        │  (pending > 0?)   │
 │                         │                        │                    │
 │                         │                        │──Clear Pending────→│
 │                         │                        │  pending = 0      │
 │                         │                        │                    │
 │                         │                        │──Transfer ETH─────→│
 │                         │                        │  to producer      │
 │                         │                        │                    │
 │                         │                        │←──Confirmation────←│
 │                         │                        │                    │
 │                         │                        │──Emit Event────────→│
 │                         │                        │  FundsWithdrawn   │
 │                         │                        │                    │
 │                         │←──Transaction Hash────←│                    │
 │                         │                        │                    │
 │←──ETH Received─────────←│                        │                    │
 │  (Check MetaMask)       │                        │                    │
 │                         │                        │                    │
 │                         │──Update Display────────│                    │
 │                         │                        │                    │
 │←──Success Message──────←│                        │                    │
 │  "Withdrawn 0.0005 ETH" │                        │                    │
 │  Pending: 0 ETH         │                        │                    │
 │                         │                        │                    │
```

## Component Interaction Matrix

```
┌──────────────────┬──────────┬──────────┬─────────────┬───────────┐
│  Component       │ Frontend │  Wallet  │   Smart     │Blockchain │
│                  │          │(MetaMask)│  Contract   │           │
├──────────────────┼──────────┼──────────┼─────────────┼───────────┤
│ Landing Page     │    ✓     │    -     │      -      │     -     │
│ Dashboard UI     │    ✓     │    -     │      -      │     -     │
│ Wallet Connect   │    ✓     │    ✓     │      -      │     ✓     │
│ User Registration│    ✓     │    ✓     │      ✓      │     ✓     │
│ List Energy      │    ✓     │    ✓     │      ✓      │     ✓     │
│ Buy Energy       │    ✓     │    ✓     │      ✓      │     ✓     │
│ Withdraw Funds   │    ✓     │    ✓     │      ✓      │     ✓     │
│ View Listings    │    ✓     │    -     │      ✓      │     ✓     │
│ View History     │    ✓     │    -     │      ✓      │     ✓     │
│ View Balance     │    ✓     │    ✓     │      ✓      │     ✓     │
└──────────────────┴──────────┴──────────┴─────────────┴───────────┘
```

## State Management

### Smart Contract State

```
┌─────────────────────────────────────────────────────────────┐
│                    CONTRACT STATE                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Owner State:                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ owner: address                                        │  │
│  │ paused: bool                                          │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  User Balances:                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ energyBalances: mapping(address => uint256)          │  │
│  │   - Tracks kWh owned by each user                    │  │
│  │   - Updated on registration, sell, buy               │  │
│  │                                                        │  │
│  │ pendingWithdrawals: mapping(address => uint256)      │  │
│  │   - ETH earned from sales, ready to withdraw         │  │
│  │   - Updated on purchase, cleared on withdraw         │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  Marketplace Data:                                          │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ listings: EnergyListing[]                            │  │
│  │   - Array of all listings (active and inactive)      │  │
│  │   - Each listing has: id, producer, amount,          │  │
│  │     pricePerKWh, active, timestamp                   │  │
│  │                                                        │  │
│  │ nextListingId: uint256                               │  │
│  │   - Counter for unique listing IDs                   │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  Transaction History:                                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ transactionHistory: mapping(address => Transaction[])│  │
│  │   - Complete history for each user                   │  │
│  │   - Includes both buy and sell transactions          │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Frontend State

```
┌─────────────────────────────────────────────────────────────┐
│                    APPLICATION STATE                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Web3 Objects:                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ provider: BrowserProvider                            │  │
│  │ signer: JsonRpcSigner                                │  │
│  │ contract: Contract                                   │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  User Info:                                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ userAddress: string                                  │  │
│  │ isOwner: boolean                                     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  UI State:                                                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ activeTab: string                                    │  │
│  │ isLoading: boolean                                   │  │
│  │ connectedNetwork: string                             │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  Cached Data:                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ currentListings: EnergyListing[]                     │  │
│  │ userListings: EnergyListing[]                        │  │
│  │ transactionHistory: Transaction[]                    │  │
│  │ userBalance: BigNumber                               │  │
│  │ pendingWithdrawal: BigNumber                         │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Security Architecture

### Multi-Layer Security Model

```
┌─────────────────────────────────────────────────────────────┐
│                    SECURITY LAYERS                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Layer 1: Smart Contract Security                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ • Access Control (onlyOwner modifier)                │  │
│  │ • Input Validation (require statements)             │  │
│  │ • Reentrancy Protection (checks-effects-interactions)│  │
│  │ • Integer Overflow Protection (Solidity 0.8+)       │  │
│  │ • Emergency Pause Mechanism                          │  │
│  │ • Event Logging for Audit Trail                     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  Layer 2: Wallet Security                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ • Private keys never exposed to frontend            │  │
│  │ • Transaction signing in MetaMask                   │  │
│  │ • User must approve each transaction                │  │
│  │ • Hardware wallet support                           │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  Layer 3: Frontend Security                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ • Network validation before transactions            │  │
│  │ • Input sanitization                                │  │
│  │ • Error handling and user feedback                  │  │
│  │ • HTTPS encryption (in production)                  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  Layer 4: Blockchain Security                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ • Immutable transaction history                     │  │
│  │ • Decentralized consensus                           │  │
│  │ • Cryptographic verification                        │  │
│  │ • Public audit trail (Etherscan)                    │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Deployment Architecture

### Development vs Production

```
DEVELOPMENT (Current):
┌──────────────────────────────────────────────────────────┐
│  Frontend: Local HTTP Server or Vercel                  │
│  ├─ index.html                                          │
│  ├─ dashboard.html                                      │
│  └─ JavaScript/CSS files                                │
└──────────────────────────────────────────────────────────┘
                       ↓
┌──────────────────────────────────────────────────────────┐
│  Blockchain: Ethereum Sepolia Testnet                   │
│  ├─ Free test ETH                                       │
│  ├─ No real money at risk                               │
│  └─ Contract: 0x501B9b7d87dA4a291E78095EF6493950...    │
└──────────────────────────────────────────────────────────┘

PRODUCTION (Future):
┌──────────────────────────────────────────────────────────┐
│  Frontend: CDN + Web Hosting (Vercel/Netlify)           │
│  ├─ HTTPS enabled                                       │
│  ├─ Optimized assets                                    │
│  └─ Rate limiting                                       │
└──────────────────────────────────────────────────────────┘
                       ↓
┌──────────────────────────────────────────────────────────┐
│  Blockchain: Ethereum Mainnet or L2 (Polygon, Arbitrum) │
│  ├─ Real ETH/MATIC transactions                         │
│  ├─ Security audited contract                           │
│  └─ Gas optimization                                    │
└──────────────────────────────────────────────────────────┘
```

## Scalability Considerations

### Current Architecture Limitations

```
┌────────────────────────────────────────────────────────┐
│  CURRENT CONSTRAINTS                                   │
├────────────────────────────────────────────────────────┤
│                                                         │
│  • Single smart contract                               │
│  • All data on-chain (expensive)                       │
│  • No pagination for large listing arrays              │
│  • Limited to Ethereum's throughput (~15 TPS)          │
│  • High gas costs on mainnet                           │
│                                                         │
└────────────────────────────────────────────────────────┘
```

### Future Scalability Solutions

```
┌────────────────────────────────────────────────────────┐
│  SCALABILITY IMPROVEMENTS                              │
├────────────────────────────────────────────────────────┤
│                                                         │
│  1. Layer 2 Solutions                                  │
│     • Deploy on Polygon, Arbitrum, or Optimism         │
│     • Lower gas fees                                   │
│     • Higher throughput                                │
│                                                         │
│  2. Off-chain Data                                     │
│     • IPFS for listing metadata                        │
│     • The Graph for indexing                           │
│     • Reduce on-chain storage costs                    │
│                                                         │
│  3. Smart Contract Optimization                        │
│     • Pagination for large arrays                      │
│     • Batch operations                                 │
│     • Gas optimization techniques                      │
│                                                         │
│  4. Caching Layer                                      │
│     • Frontend caching of frequent queries             │
│     • Backend API for aggregated data                  │
│     • Redis/Memcached for hot data                     │
│                                                         │
└────────────────────────────────────────────────────────┘
```

## Technology Stack Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    TECHNOLOGY STACK                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Blockchain:                                                │
│  └─ Ethereum (Sepolia Testnet)                             │
│                                                              │
│  Smart Contract:                                            │
│  ├─ Solidity ^0.8.19                                       │
│  └─ Remix IDE for development                              │
│                                                              │
│  Frontend:                                                  │
│  ├─ HTML5                                                  │
│  ├─ CSS3 (Custom styling)                                  │
│  └─ JavaScript (ES6+)                                      │
│                                                              │
│  Web3 Integration:                                          │
│  ├─ Web3.js v1.8.0                                         │
│  ├─ Ethers.js                                              │
│  └─ MetaMask (Browser wallet)                              │
│                                                              │
│  Libraries:                                                 │
│  └─ SweetAlert2 (UI dialogs)                               │
│                                                              │
│  Hosting:                                                   │
│  └─ Vercel (Frontend)                                      │
│                                                              │
│  Development Tools:                                         │
│  ├─ Git/GitHub (Version control)                           │
│  ├─ VS Code (Code editor)                                  │
│  └─ Sepolia Etherscan (Block explorer)                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*This architecture document provides a comprehensive technical overview of the Shakti Exchange platform. For implementation details, see PROJECT_EXPLANATION.md. For getting started, see QUICK_START_GUIDE.md.*
