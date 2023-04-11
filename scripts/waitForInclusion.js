const hre = require('hardhat')
const fetch = require('isomorphic-fetch')
const wait = require('wait')
require('dotenv').config()

async function main() {
  console.log('Waiting for L2 root inclusion (this may take up to 20 minutes)...')
  while (true) {
    const l1TxHash = process.env.L1_TX_HASH
    const l2Contract = process.env.L2_CONTRACT
    const url = `https://bridge-api.public.zkevm-test.net/bridges/${l2Contract}?limit=25&offset=0`
    const res = await fetch(url)
    const json = await res.json()
    for (const item of json.deposits) {
      if (item.tx_hash === l1TxHash) {
        if (item.ready_for_claim) {
          console.log(JSON.stringify(item, null, 2))
          console.log('Ready to finalize message')
          process.exit(0)
        }
      }
    }
    await wait (10 * 1000)
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
