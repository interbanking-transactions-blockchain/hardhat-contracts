async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Contracts deployed successfully!");
  }
  
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });