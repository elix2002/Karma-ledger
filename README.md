# Karma Ledger Smart Contract

A Clarity smart contract for tracking and managing "karma" points between users on the Stacks blockchain. This contract allows users to give karma to others, view karma scores, and enables an admin to reset, ban, or unban users.

## Features

- **Give Karma:** Users can give karma points to others with a reason.
- **Prevent Abuse:** Users cannot give karma to themselves or repeatedly to the same user.
- **Karma History:** Tracks the last recipient of karma from each user.
- **Admin Controls:** Admin can reset a user's karma, ban/unban users from giving karma.
- **Banned Users:** Banned users cannot give karma.
- **Karma Query:** Anyone can query a user's karma score and reason.

## Contract Structure

- `karma-points`: Map storing each user's karma score and last reason.
- `karma-history`: Map storing the last recipient of karma from each user.
- `banned-users`: Map tracking which users are banned from giving karma.
- `admin`: Constant holding the admin principal address.

## Key Functions

- `give-karma (recipient principal) (reason (string-ascii 100))`: Give karma to another user.
- `get-karma (user principal)`: Read-only; get a user's karma score and reason.
- `reset-karma (user principal)`: Admin only; reset a user's karma.
- `ban-user (user principal)`: Admin only; ban a user from giving karma.
- `unban-user (user principal)`: Admin only; unban a user.
- `is-banned (user principal)`: Read-only; check if a user is banned.

## Usage

1. **Deploy the contract** to the Stacks blockchain using [Clarinet](https://docs.stacks.co/write-smart-contracts/clarinet).
2. **Call public functions** using your wallet or a Clarity-compatible interface.
3. **Admin actions** require the transaction sender to match the `admin` principal set in the contract.

## Development

- Written in [Clarity](https://docs.stacks.co/write-smart-contracts/clarity-language).
- See `.gitignore` for ignored files and folders.
- Contributions and issues are welcome!

## Example

```clarity
;; Give karma to another user
(define-public (give-karma (recipient principal) (reason (string-ascii 100)))
  ;; Implementation here
