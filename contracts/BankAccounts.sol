// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./StableCoin.sol";

contract BankAccounts {

    struct BankNode {
        string name;
        address account;
        string publicKey;
        string enode;
    }

    // Mapping of bank nodes: public key => BankNode
    mapping(string => BankNode) public bankNodes;

    // Counter for the number of bank nodes
    uint256 public bankNodeCount;

    // StableCoin contract
    StableCoin public stableCoin;

    // ~ ~ ~ ~ ~ ~ ~ CREATE Methods ~ ~ ~ ~ ~ ~ ~ //

    // Add a new bank node
    function addNode(string memory name, string memory publicKey, string memory enode, address account, uint256 reserves) public {
        bankNodes[publicKey] = BankNode(name, account, publicKey, enode);
        bankNodeCount++;
        stableCoin.mintBank(account, reserves);
    }

    // ~ ~ ~ ~ ~ ~ ~ UPDATE Methods ~ ~ ~ ~ ~ ~ ~ //

    // Update the name of a bank node
    function updateNodeName(string memory publicKey, string memory name) public {
        bankNodes[publicKey].name = name;
    }

    // Update the public key of a bank node
    function updateNodePrivateKey(string memory oldPublicKey, string memory newPublicKey) public {
        BankNode storage node = bankNodes[oldPublicKey];
        node.publicKey = newPublicKey;
        bankNodes[newPublicKey] = node;
        delete bankNodes[oldPublicKey];
    }

    // Update the enode of a bank node
    function updateNodeEnode(string memory publicKey, string memory enode) public {
        bankNodes[publicKey].enode = enode;
    }

    // Update the account of a bank node
    function updateNodeAccount(string memory publicKey, address account) public {
        bankNodes[publicKey].account = account;
    }

    // ~ ~ ~ ~ ~ ~ ~ REMOVE Methods ~ ~ ~ ~ ~ ~ ~ //

    // Remove a bank node
    function removeNode(string memory publicKey) public {
        delete bankNodes[publicKey];
        bankNodeCount--;
        // Burn all the reserves of the bank
        uint256 reserves = stableCoin.balanceOf(bankNodes[publicKey].account);
        if (reserves > 0) {
            stableCoin.burnBank(bankNodes[publicKey].account, reserves);
        }
    }

    // ~ ~ ~ ~ ~ ~ ~ GET Methods ~ ~ ~ ~ ~ ~ ~ //

    // Get the name of a bank node
    function getNodeName(string memory publicKey) public view returns (string memory) {
        return bankNodes[publicKey].name;
    }

    // Get the account of a bank node
    function getNodeAccount(string memory publicKey) public view returns (address) {
        return bankNodes[publicKey].account;
    }

    // Get the enode of a bank node
    function getNodeEnode(string memory publicKey) public view returns (string memory) {
        return bankNodes[publicKey].enode;
    }

    // Get a bank node by its public key
    function getNode(string memory publicKey) public view returns (BankNode memory) {
        return bankNodes[publicKey];
    }

    // Check if a bank node exists
    function nodeExists(string memory publicKey) public view returns (bool) {
        return keccak256(abi.encodePacked(bankNodes[publicKey].publicKey)) == keccak256(abi.encodePacked(publicKey));
    }

    // Check if combination of node public key and bank name exists
    function nodeExistsByName(string memory publicKey, string memory name) public view returns (bool) {
        return keccak256(abi.encodePacked(bankNodes[publicKey].name)) == keccak256(abi.encodePacked(name));
    }

    // ~ ~ ~ ~ ~ ~ ~ GET ALL Methods ~ ~ ~ ~ ~ ~ ~ //

    // Get all bank nodes
    function getAllBankNodes() public view returns (BankNode[] memory) {
        BankNode[] memory nodes = new BankNode[](bankNodeCount);
        uint256 index = 0;
        for (uint256 i = 0; i < bankNodeCount; i++) {
            BankNode storage node = bankNodes[string(abi.encodePacked(i))];
            nodes[index] = node;
            index++;
        }
        return nodes;
    }

    // Get all enodes
    function getAllEnodes() public view returns (string[] memory) {
        string[] memory enodes = new string[](bankNodeCount);
        uint256 index = 0;
        for (uint256 i = 0; i < bankNodeCount; i++) {
            BankNode storage node = bankNodes[string(abi.encodePacked(i))];
            enodes[index] = node.enode;
            index++;
        }
        return enodes;
    }

}