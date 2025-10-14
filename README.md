# ShaktiExchange: Peer-to-Peer Energy Trading Platform 

&nbsp;

## 🖼️ Screenshot
![ShaktiExchange Dashboard](assets/dashboard.png)

## 🚀 Deployment 

[![Deployed on Vercel](https://img.shields.io/badge/Deployed%20on-Vercel-black?style=for-the-badge&logo=vercel)](shakti-exchange.vercel.app/)

[![Live Project](https://img.shields.io/badge/Live%20Project-shakti--exchange.vercel.app-green?style=for-the-badge&logo=vercel)](shakti-exchange.vercel.app/)

## 🌟 Overview

ShaktiExchange is a revolutionary platform enabling peer-to-peer energy trading, putting the power back into the hands of consumers and small-scale energy producers. Our platform facilitates direct energy transactions between neighbors, reducing dependency on centralized power grids and promoting sustainable energy usage.

## ✨ Features

- 🔄 **P2P Energy Trading**: Directly trade excess energy with neighbors and local businesses
- 📊 **Real-time Dashboard**: Monitor your energy production, consumption, and trading activity
- 💰 **Smart Pricing**: Algorithm-based pricing adjustments based on supply and demand
- 🔐 **Secure Transactions**: Safe and transparent energy trading using modern web technologies
- 📱 **Responsive Design**: Seamless experience across desktop and mobile devices

## 🛠️ Technologies

- **Frontend**: HTML5, CSS3, JavaScript
- **UI Components**: Modern, responsive design with custom styling
- **Data Visualization**: Real-time energy monitoring and trading graphs
- **Security**: Encrypted data transfer and secure user authentication

## 📋 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/shubhamaher8/Shakti-Exchange.git
   ```

2. Open `index.html` in your browser to view the landing page

3. Navigate to `dashboard.html` to explore the dashboard interface

## 📊 Project Structure

```
ShaktiExchange/
├── index.html                  # Landing page
├── dashboard.html              # User dashboard
├── app.js                      # Main application logic
├── app_landing.js              # Landing page functionality
├── config.js                   # Configuration settings
├── style.css                   # Main stylesheet
├── style_landing.css           # Landing page styles
├── EnergyTradingSimple.sol     # Smart contract (Solidity)
├── PROJECT_EXPLANATION.md      # Complete technical documentation
├── QUICK_START_GUIDE.md        # Beginner-friendly guide
└── assets/                     # Images, icons, and other static resources
```

## 📚 Documentation

### For Beginners:
- **[Quick Start Guide](QUICK_START_GUIDE.md)** - Step-by-step instructions for your first trade
- Visual walkthrough of all features
- Common questions answered
- 5-minute first transaction guide

### For Developers:
- **[Project Explanation](PROJECT_EXPLANATION.md)** - Complete technical documentation
- Architecture diagrams and flow charts
- Smart contract detailed analysis
- Security features and best practices
- Setup and deployment instructions
- Troubleshooting guide

## 🔧 Technical Overview

### Smart Contract
- **Language**: Solidity ^0.8.19
- **Network**: Ethereum Sepolia Testnet
- **Contract Address**: `0x501B9b7d87dA4a291E78095EF6493950f6c55250`
- **Features**:
  - Decentralized energy listing and trading
  - Automated escrow and settlement
  - Transaction history tracking
  - Emergency pause mechanism
  - Owner administrative controls

### Frontend Integration
- **Web3 Library**: Web3.js v1.8.0 & Ethers.js
- **Wallet**: MetaMask integration
- **API**: JSON-RPC communication with Ethereum
- **UI**: Responsive design with modern CSS

### Key Functions
```javascript
// User Registration
registerAsProducer()
registerAsConsumer()

// Trading Operations
sellEnergy(amount, pricePerKWh)
buyEnergy(listingId)
withdrawFunds()

// Data Retrieval
getListings()
getUserListings(address)
getTransactionHistory(address)
```

## 🌱 Sustainability Impact

ShaktiExchange aims to:

- ♻️ Reduce carbon footprint by optimizing local energy usage
- 💡 Encourage adoption of renewable energy sources
- 🏘️ Build resilient energy communities
- 💪 Empower individuals to participate in the energy transition

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to help improve ShaktiExchange.

## 📜 License

This project is licensed under the [GNU General Public License v3.0](LICENSE)

