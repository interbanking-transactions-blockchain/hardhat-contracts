// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract BankAccounts {

    struct BankNode {
        string name;
        address account;
        string publicKey;
        string enode;
        string rpcEndpoint;
    }

    // Mapping of bank nodes: public key => BankNode
    mapping(string => BankNode) public bankNodes;

    // Counter for the number of bank nodes
    uint256 public bankNodeCount;

    // ~ ~ ~ ~ ~ ~ ~ CREATE Methods ~ ~ ~ ~ ~ ~ ~ //

    // Add a new bank node
    function addNode(string memory name, string memory publicKey, string memory enode, address account, string memory rpcEndpoint) public {
        bankNodes[publicKey] = BankNode(name, account, publicKey, enode, rpcEndpoint);
        bankNodeCount++;
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

    // Update the rpc endpoint of a bank node
    function updateNodeRpcEndpoint(string memory publicKey, string memory rpcEndpoint) public {
        bankNodes[publicKey].rpcEndpoint = rpcEndpoint;
    }

    // ~ ~ ~ ~ ~ ~ ~ REMOVE Methods ~ ~ ~ ~ ~ ~ ~ //

    // Remove a bank node
    function removeNode(string memory publicKey) public {
        delete bankNodes[publicKey];
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

    // Get the rpc endpoint of a bank node
    function getNodeRpcEndpoint(string memory publicKey) public view returns (string memory) {
        return bankNodes[publicKey].rpcEndpoint;
    }

    // Check if a bank node exists
    function nodeExists(string memory publicKey) public view returns (bool) {
        return keccak256(abi.encodePacked(bankNodes[publicKey].publicKey)) == keccak256(abi.encodePacked(publicKey));
    }

    // Check if an account exists
    function accountExists(address account) public view returns (bool) {
        for (uint256 i = 0; i < bankNodeCount; i++) {
            if (bankNodes[string(abi.encodePacked(i))].account == account) {
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

    // Get all aaddresses
    function getAllAddresses() public view returns (address[] memory) {
        address[] memory addresses = new address[](bankNodeCount);
        uint256 index = 0;
        for (uint256 i = 0; i < bankNodeCount; i++) {
            BankNode storage node = bankNodes[string(abi.encodePacked(i))];
            addresses[index] = node.account;
            index++;
        }
        return addresses;
    }

    // Get all rpc endpoints
    function getAllRpcEndpoints() public view returns (string[] memory) {
        string[] memory rpcEndpoints = new string[](bankNodeCount);
        uint256 index = 0;
        for (uint256 i = 0; i < bankNodeCount; i++) {
            BankNode storage node = bankNodes[string(abi.encodePacked(i))];
            rpcEndpoints[index] = node.rpcEndpoint;
            index++;
        }
        return rpcEndpoints;
    }

}