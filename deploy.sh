# When using ignition there is no need to compile
# Uncomment if you want to compile

# npx hardhat compile

# For deployment in besu network this is not longer used

# npx hardhat ignition deploy ./ignition/modules/Lock.js --network localhost

npx hardhat ignition deploy ./ignition/modules/Lock.js --network besu

npx hardhat ignition deploy ./ignition/modules/StableCoinDeploy.js --network besu