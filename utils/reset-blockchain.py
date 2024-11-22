import os

# Command to change directory

blockchain_project = "../interbank-blockchain"

cd_command = "clear && cd " + blockchain_project

commands = [
    # Change directory
    cd_command,
    
    # Remove data folder
    "sudo rm -rf data",
    
    # Stop all containers
    "sudo docker stop $(sudo docker ps -q)",
    
    # Remove all containers
    "sudo docker rm $(sudo docker ps -a -q)",
    
    # Remove all networks
    "sudo docker network prune -f"
]

for command in commands:
    os.system(command)