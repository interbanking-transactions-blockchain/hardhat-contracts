// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
require("dotenv").config();

// DEPOSIT_ACCOUNT is the deposit account defined in the genesis file
const DEPOSIT_ACCOUNT = process.env.DEPOSIT_ACCOUNT;

module.exports = buildModule("StableCoinModule", (m) => {
  const depositAccount = m.getParameter("depositAccount", DEPOSIT_ACCOUNT);
  const stableCoin = m.contract("StableCoin", [depositAccount]);
  return { stableCoin };
});
