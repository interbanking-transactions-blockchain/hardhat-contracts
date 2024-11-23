// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract BankAccounts {

    struct BankNode {
        string name;
        address[] accounts;
        string publicKey;
        string enode;
    }

    // Mapping of bank nodes: public key => BankNode
    mapping(string => BankNode) public bankNodes;
    // Counter for the number of bank nodes
    uint256 public bankNodeCount;

    // ~ ~ ~ ~ ~ ~ ~ CREATE Methods ~ ~ ~ ~ ~ ~ ~ //

    // Add a new bank node
    function addNode(string memory name, string memory publicKey, string memory enode) public {
        bankNodes[publicKey] = BankNode(name, new address[](0), publicKey, enode);
        bankNodeCount++;
    }

    // Add a new account to a bank node
    function addAccount(string memory publicKey, address account) public {
        BankNode storage node = bankNodes[publicKey];
        // Check if the account already exists in the bank node
        bool exists = false;
        for (uint256 i = 0; i < node.accounts.length; i++) {
            if (node.accounts[i] == account) {
                exists = true;
                break;
            }
        }
        
        // If the account does not exist, add it to the bank node
        if (!exists) {
            node.accounts.push(account);
        }
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

    // ~ ~ ~ ~ ~ ~ ~ REMOVE Methods ~ ~ ~ ~ ~ ~ ~ //

    // Remove a bank node
    function removeNode(string memory publicKey) public {
        delete bankNodes[publicKey];
        bankNodeCount--;
    }

    // Remove an account from a bank node
    function removeAccount(string memory publicKey, address account) public {
        BankNode storage node = bankNodes[publicKey];
        address[] storage accounts = node.accounts;
        for (uint i = 0; i < accounts.length; i++) {
            if (accounts[i] == account) {
                accounts[i] = accounts[accounts.length - 1];
                accounts.pop();
                break;
            }
        }
    }

    // ~ ~ ~ ~ ~ ~ ~ GET Methods ~ ~ ~ ~ ~ ~ ~ //

    // Get the name of a bank node
    function getNodeName(string memory publicKey) public view returns (string memory) {
        return bankNodes[publicKey].name;
    }

    // Get the accounts of a bank node
    function getNodeAccounts(string memory publicKey) public view returns (address[] memory) {
        return bankNodes[publicKey].accounts;
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

    // Check if an account exists in a bank node
    function accountExists(string memory publicKey, address account) public view returns (bool) {
        BankNode storage node = bankNodes[publicKey];
        address[] storage accounts = node.accounts;
        for (uint i = 0; i < accounts.length; i++) {
            if (accounts[i] == account) {
                return true;
            }
        }
        return false;
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