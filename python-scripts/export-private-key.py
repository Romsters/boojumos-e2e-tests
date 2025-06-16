#!/usr/bin/env python3

import argparse
import json
from eth_account import Account

# Set up argument parser
parser = argparse.ArgumentParser(description='Decrypt an Ethereum keystore file.')
parser.add_argument('keystore_path', help='Path to the keystore file')
parser.add_argument('password', help='Password to decrypt the keystore')

args = parser.parse_args()

# Load keystore
with open(args.keystore_path) as f:
    keystore = json.load(f)

# Decrypt and extract private key
acct = Account.decrypt(keystore, args.password)
private_key = acct.hex()

# Output the private key
print(private_key)
