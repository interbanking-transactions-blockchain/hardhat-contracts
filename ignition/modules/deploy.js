const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

require("dotenv").config();

const DEPOSIT_ACCOUNT = process.env.DEPOSIT_ACCOUNT;

module.exports = buildModule("DeployModule", (m) => {
  const bankAccounts = m.contract("BankAccounts");

  const depositAccount = m.getParameter("depositAccount", DEPOSIT_ACCOUNT);
  const stableCoin = m.contract("StableCoin", [depositAccount]);

  return { bankAccounts, stableCoin };
});