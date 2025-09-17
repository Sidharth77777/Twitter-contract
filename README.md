# Twitter-contract
Decentralized Twitter-like application written in Solidity. Supports creating tweets, liking/unliking, and managing tweet length with on-chain storage.

## Features
- Post tweets with length limit (default 280 characters)
- Like and unlike tweets
- Track likes count per tweet
- Admin can change max tweet length

## Stack
- Solidity ^0.8.20
- Remix IDE for testing
- Deployable on Ethereum testnets

## How to run
1. Open `contracts/Twitter.sol` in [Remix IDE](https://remix.ethereum.org/).
2. Compile using Solidity 0.8.20.
3. Deploy to JavaScript VM or Injected Web3 (MetaMask).
