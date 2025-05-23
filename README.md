# BitStacksDAO

## Decentralized Governance for Stacks L2

BitStacksDAO is a decentralized autonomous organization (DAO) smart contract built on the Stacks Layer 2 blockchain. It enables a secure and democratic system for token-based governance, where community members can propose, vote, and execute decisions transparently using STX tokens.

---

## 🚀 Features

* **STX-Backed Governance**: Users deposit STX to mint governance tokens that provide voting power.
* **Decentralized Proposal System**: Any user holding governance tokens can submit proposals.
* **Voting Mechanism**: One-token-one-vote system allowing weighted decision-making.
* **Execution Engine**: Automatically executes proposals that pass quorum after expiration.
* **Security & Compliance**: Time-locked deposits and strict validation logic protect the DAO’s treasury.

---

## 📚 Overview

### Governance Flow

1. **Deposit STX**
   Users deposit STX tokens to mint governance tokens (1:1 ratio), which are locked for a predefined period.

2. **Create Proposal**
   Token holders propose how funds should be used, including amount, target address, and purpose.

3. **Vote**
   All holders vote before the proposal expires. Votes are weighted based on governance token balance.

4. **Execute**
   If a proposal receives more “yes” than “no” votes and passes the time lock, the specified amount is transferred to the target address.

---

## 🧱 Architecture

```plaintext
+-------------------+      +-----------------------+
|     User Wallet   |<---> |  BitStacksDAO Contract|
+-------------------+      +-----------------------+
         |                          |
         | Deposit STX             |
         v                          v
+-------------------+      +-----------------------+
| Governance Tokens |<---->|    Deposit Records     |
+-------------------+      +-----------------------+
         |                          |
         |   Vote / Propose         |
         v                          v
+-------------------+      +-----------------------+
|   Voting Records  |<---->|      Proposals         |
+-------------------+      +-----------------------+
         |                          |
         | Execute (if passed)      |
         v                          v
+-------------------+      +-----------------------+
| STX Treasury Pool |----->| Proposal Target Wallet |
+-------------------+      +-----------------------+
```

---

## 📦 Contract Functions

### Public Functions

| Function           | Description                            |
| ------------------ | -------------------------------------- |
| `initialize`       | Initialize the contract (owner-only)   |
| `deposit`          | Deposit STX and mint governance tokens |
| `withdraw`         | Withdraw STX after the lock period     |
| `create-proposal`  | Submit a new proposal                  |
| `vote`             | Cast a vote on a proposal              |
| `execute-proposal` | Execute a passed proposal              |

### Read-Only Functions

| Function           | Description                                |
| ------------------ | ------------------------------------------ |
| `get-balance`      | Get governance token balance of an account |
| `get-total-supply` | Total governance tokens in circulation     |
| `get-proposal`     | View details of a specific proposal        |
| `get-deposit-info` | View locked STX and metadata for a user    |
| `get-vote`         | Check a user's vote on a proposal          |

---

## 🔒 Security and Compliance

* Uses Stacks L2 for scalability while maintaining Bitcoin security via Proof of Transfer.
* Time-locks and voting constraints prevent unauthorized or rushed decision-making.
* Only executable proposals with a democratic majority.

---

## 🛠 Deployment Requirements

* **Stacks Blockchain**
* **Clarity Language Environment**
* Recommended: Use [Clarinet](https://docs.stacks.co/write-smart-contracts/clarinet) for local development and testing.
