#!/usr/bin/env python3

import argparse
from web3 import Web3

def main():
    parser = argparse.ArgumentParser(
        description="Send Ether with Web3.py (defaults assume a local dev node)."
    )
    parser.add_argument(
        "--url",
        default="http://localhost:8545",
        help="Ethereum JSON-RPC endpoint (default: %(default)s)",
    )
    parser.add_argument(
        "--coinbase",
        default=None,
        help="Sender (from) account address. If omitted, the node’s coinbase or first account is used.",
    )
    parser.add_argument(
        "--to",
        dest="recipient",
        default=None,
        help="Recipient (to) account address. If omitted, the node’s second account is used.",
    )
    parser.add_argument(
        "--eth",
        type=float,
        default=5.0,
        help="Amount of Ether to send (default: %(default)s)",
    )

    args = parser.parse_args()

    # Connect to node
    w3 = Web3(Web3.HTTPProvider(args.url))
    if not w3.is_connected():
        raise ConnectionError(f"Could not connect to RPC at {args.url}")

    # Resolve default accounts if necessary
    accounts = w3.eth.accounts
    if not accounts:
        raise RuntimeError("No accounts available on the connected node.")

    coinbase = args.coinbase or accounts[0]
    recipient = args.recipient or (accounts[1] if len(accounts) > 1 else None)
    if recipient is None:
        raise ValueError("No recipient address specified and no second account available.")

    # Convert ETH float to wei
    wei_value = w3.to_wei(args.eth, "ether")

    # Send the transaction
    tx_hash = w3.eth.send_transaction(
        {
            "from": Web3.to_checksum_address(coinbase),
            "to": Web3.to_checksum_address(recipient),
            "value": wei_value,
        }
    )

    print("Transaction sent. Hash:", tx_hash.hex())
    receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Transaction confirmed in block", receipt.blockNumber)
    print(receipt)

if __name__ == "__main__":
    main()
