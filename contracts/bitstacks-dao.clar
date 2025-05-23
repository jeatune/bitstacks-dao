;; Title: BitStacksDAO - Decentralized Governance for Stacks
;;
;; Summary:
;; A decentralized autonomous organization (DAO) smart contract for Stacks L2, 
;; enabling token-based governance with secure STX management, proposal creation,
;; voting, and execution of community decisions.
;;
;; Description:
;; BitStacksDAO implements a governance system where users can deposit STX tokens
;; to receive governance tokens proportional to their deposit. These governance tokens
;; provide voting power on proposals that determine fund allocation. The contract
;; features time-locked deposits, proposal creation with customizable durations,
;; democratic voting, and automatic proposal execution when approved.
;;
;; The system maintains strong Bitcoin compliance through Stacks' Proof of Transfer
;; consensus mechanism while providing the scalability advantages of Stacks Layer 2.

;; Constants

;; Error codes
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-initialized (err u101))
(define-constant err-already-initialized (err u102))
(define-constant err-insufficient-balance (err u103))
(define-constant err-invalid-amount (err u104))
(define-constant err-unauthorized (err u105))
(define-constant err-proposal-not-found (err u106))
(define-constant err-proposal-expired (err u107))
(define-constant err-already-voted (err u108))
(define-constant err-below-minimum (err u109))
(define-constant err-locked-period (err u110))
(define-constant err-transfer-failed (err u111))
(define-constant err-invalid-duration (err u112))
(define-constant err-zero-amount (err u113))
(define-constant err-invalid-target (err u114))
(define-constant err-invalid-description (err u115))
(define-constant err-invalid-proposal-id (err u116))
(define-constant err-invalid-vote (err u117))

;; Governance parameters
(define-constant minimum-duration u144) ;; minimum 1 day (assuming 10min blocks)
(define-constant maximum-duration u20160) ;; maximum 14 days

;; Data Variables

(define-data-var total-supply uint u0)
(define-data-var minimum-deposit uint u1000000) ;; in microSTX
(define-data-var lock-period uint u1440) ;; ~10 days in blocks
(define-data-var initialized bool false)
(define-data-var last-rebalance uint u0)
(define-data-var proposal-count uint u0)

;; Data Maps

;; Token balances for governance
(define-map balances
  principal
  uint
)

;; User deposits with lock periods
(define-map deposits
  principal
  {
    amount: uint,
    lock-until: uint,
    last-reward-block: uint,
  }
)

;; Governance proposals
(define-map proposals
  uint
  {
    proposer: principal,
    description: (string-ascii 256),
    amount: uint,
    target: principal,
    expires-at: uint,
    executed: bool,
    yes-votes: uint,
    no-votes: uint,
  }
)

;; Vote tracking
(define-map votes
  {
    proposal-id: uint,
    voter: principal,
  }
  bool
)

;; Private Functions

;; Check if caller is contract owner
(define-private (is-contract-owner)
  (is-eq tx-sender contract-owner)
)

;; Verify contract has been initialized
(define-private (check-initialized)
  (ok (asserts! (var-get initialized) err-not-initialized))
)

;; Validate proposal ID exists
(define-private (validate-proposal-id (proposal-id uint))
  (ok (asserts! (<= proposal-id (var-get proposal-count)) err-invalid-proposal-id))
)

;; Calculate voter's governance power
(define-private (calculate-voting-power (voter principal))
  (default-to u0 (map-get? balances voter))
)

;; Transfer governance tokens between accounts
(define-private (transfer-tokens
    (sender principal)
    (recipient principal)
    (amount uint)
  )
  (let (
      (sender-balance (default-to u0 (map-get? balances sender)))
      (recipient-balance (default-to u0 (map-get? balances recipient)))
    )
    (asserts! (>= sender-balance amount) err-insufficient-balance)
    (map-set balances sender (- sender-balance amount))
    (map-set balances recipient (+ recipient-balance amount))
    (ok true)
  )
)

;; Mint new governance tokens
(define-private (mint-tokens
    (account principal)
    (amount uint)
  )
  (let ((current-balance (default-to u0 (map-get? balances account))))
    (map-set balances account (+ current-balance amount))
    (var-set total-supply (+ (var-get total-supply) amount))
    (ok true)
  )
)