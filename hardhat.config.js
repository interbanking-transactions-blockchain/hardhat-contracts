require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();


// besuUrl is the url where the bootnode a is deployed
const besuUrl = process.env.BESU_URL_NODE_A;

// privateKey is the privateKey of the bootnode a which is the one that sign the tx that deploy the smart contract
const privateKey = process.env.PRIVATE_KEY_BOOTNODE_A;

module.exports = {
  solidity: "0.8.27",
  networks: {
    besu: {
      url: besuUrl,
      accounts: [privateKey],
    },
  },
};
