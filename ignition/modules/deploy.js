async function main() {
    const [deployer] = await ethers.getSigners();
  
    // Deploy Mock EURC
    const EURCToken = await ethers.getContractFactory("MockEURC");
    const eurcToken = await EURCToken.deploy(deployer.address);
  
    // Deploy Price Oracle
    const PriceOracle = await ethers.getContractFactory("PriceOracle");
    const priceOracle = await PriceOracle.deploy(deployer.address);
  
    // Deploy Institution Registry
    const InterbankRegistry = await ethers.getContractFactory("InterbankRegistry");
    const registry = await InterbankRegistry.deploy(deployer.address);
  
    // Deploy Transaction Manager
    const TransactionManager = await ethers.getContractFactory("InterbankTransactionManager");
    const transactionManager = await TransactionManager.deploy(
      eurcToken.target, 
      priceOracle.target, 
      registry.target
    );
  
    console.log("Contracts deployed successfully!");
  }
  
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });