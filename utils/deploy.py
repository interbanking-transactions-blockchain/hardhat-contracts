#npx hardhat compile

# npx hardhat ignition deploy ./ignition/modules/Lock.js --network localhost

import os

network = "http://172.20.0.3:8545"

os.system(f"npx hardhat compile")

modules = [
    "Lock"
]

for module in modules:
    os.system(f"npx hardhat ignition deploy ./ignition/modules/{module}.js --network {network}")