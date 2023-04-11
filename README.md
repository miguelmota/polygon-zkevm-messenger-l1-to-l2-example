# Polygon zkEVM Messenger L1->L2 Example

> Send a message from L1 Goerli to L2 [Polygon zkEVM](https://polygon.technology/polygon-zkevm) testnet.

## Example

There's two contracts; `L2Contract.sol` and `L1Contract.sol`

The L1 contract has a method `sendMessageToL2` that sends a message from L1 to L2 contract to set a greeting message on L2 contract.
It sends the encoded calldata to execute `setGreeting` on L2 which can only be called if the message was sent by the L1 contract.

### Files

- [`L2Contract.sol`](./contracts/L2Contract.sol)
- [`L1Contract.sol`](./contracts/L1Contract.sol)
- [`deployL2.js`](./script/deployL2.js)
- [`deployL1.js`](./scripts/deployL1.js)
- [`sendL1ToL2Message.js`](./scripts/sendL1ToL2Message.js)
- [`waitForInclusion.js`](./scripts/waitForInclusion.js)
- [`finalizeMessageOnL2.js`](./scripts/finalizeMessageOnL2.js)
- [`getGreetingOnL2.js`](./scripts/getGreetingOnL2.js)

## Install

```sh
git clone https://github.com/miguelmota/polygon-zkevm-messenger-l1-to-l2-example.git
cd polygon-zkevm-messenger-l1-to-l2-example
npm install
```

### Set Signer

Create `.env`

```sh
PRIVATE_KEY=123...
```

Make sure private key has funds on both Goerli and Polygon zkEVM testnet.

### Compile Contracts

```sh
npx hardhat compile
```

### Deploy L1 Contract

Command

```sh
npx hardhat run --network goerli scripts/deployL1.js
```

Output

```sh
L1Contract deployed to: 0xF20b8Fd13c48b68d1820cFd6d0D531a383b1AAaD
```

### Deploy L2 Contract

Command

```sh
L1_CONTRACT=0xF20b8Fd13c48b68d1820cFd6d0D531a383b1AAaD \
npx hardhat run --network polygonzkevm scripts/deployL2.js
```

Output

```sh
L2Contract deployed to: 0x7aEF554acf5fBaCd2161027F24528f33fc7fCA95
```
0x7aEF554acf5fBaCd2161027F24528f33fc7fCA95

### Send L1->L2 Message

Command (replace env vars with your values)

```sh
GREETING="hello world" \
L1_CONTRACT=0xF20b8Fd13c48b68d1820cFd6d0D531a383b1AAaD \
L2_CONTRACT=0x7aEF554acf5fBaCd2161027F24528f33fc7fCA95 \
npx hardhat run --network goerli scripts/sendL1ToL2Message.js
```

Output

```sh
sent tx hash 0xdc954d46caa59e41710a70a4a5b0204fdb3f9f7aae983179a3ee6bfb82ad19bc
https://goerli.etherscan.io/tx/0xdc954d46caa59e41710a70a4a5b0204fdb3f9f7aae983179a3ee6bfb82ad19bc
```

### Wait for L2 Root Inclusion

Command

```sh
L1_TX_HASH=0xdc954d46caa59e41710a70a4a5b0204fdb3f9f7aae983179a3ee6bfb82ad19bc \
L2_CONTRACT=0x7aEF554acf5fBaCd2161027F24528f33fc7fCA95 \
npx hardhat run --network polygonzkevm scripts/waitForInclusion.js
```

Output

```sh
Waiting for L2 root inclusion (this may take up to 20 minutes)...
{
  "leaf_type": 1,
  "orig_net": 0,
  "orig_addr": "0xF20b8Fd13c48b68d1820cFd6d0D531a383b1AAaD",
  "amount": "0",
  "dest_net": 1,
  "dest_addr": "0x7aEF554acf5fBaCd2161027F24528f33fc7fCA95",
  "block_num": "8811178",
  "deposit_cnt": "82717",
  "network_id": 0,
  "tx_hash": "0xdc954d46caa59e41710a70a4a5b0204fdb3f9f7aae983179a3ee6bfb82ad19bc",
  "claim_tx_hash": "",
  "metadata": "0xa41368620000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000b68656c6c6f20776f726c64000000000000000000000000000000000000000000",
  "ready_for_claim": true
}
Ready to finalize message
```

### Finalize Message On L2

Command

```sh
L1_TX_HASH=0xdc954d46caa59e41710a70a4a5b0204fdb3f9f7aae983179a3ee6bfb82ad19bc \
L1_CONTRACT=0xF20b8Fd13c48b68d1820cFd6d0D531a383b1AAaD \
L2_CONTRACT=0x7aEF554acf5fBaCd2161027F24528f33fc7fCA95 \
npx hardhat run --network polygonzkevm scripts/finalizeMessageOnL2.js
```

Output

```sh
verified: true
sent tx hash 0xc98c79f95131148057d79411d55521b145f5c5cbf63df909539dbe589605ab63
https://testnet-zkevm.polygonscan.com/tx/0xc98c79f95131148057d79411d55521b145f5c5cbf63df909539dbe589605ab63
```

### Get Greeting on L2

Command

```sh
L2_CONTRACT=0x7aEF554acf5fBaCd2161027F24528f33fc7fCA95 \
npx hardhat run --network polygonzkevm scripts/getGreetingOnL2.js
```

Output

```sh
greeting: hello world
```

### Send L2->L1 Message

See [https://github.com/miguelmota/polygon-zkevm-messenger-l2-to-l1-example](https://github.com/miguelmota/polygon-zkevm-messenger-l2-to-l1-example)

## License

[MIT](./LICENSE) @ [Miguel Mota](https://github.com/miguelmota)
