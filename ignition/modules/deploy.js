const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("DeployModule", (m) => {
  const bankAccounts = m.contract("BankAccounts");
  return { bankAccounts };
});