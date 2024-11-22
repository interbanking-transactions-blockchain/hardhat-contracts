// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract BankAccounts {

    struct BankNode {
        string name;
        address[] accounts;
        bytes32 publicKey;
    }

    // Mapping of bank nodes: public key => BankNode
    mapping(bytes32 => BankNode) public bankNodes;

    // ~ ~ ~ ~ ~ ~ ~ ADD Methods ~ ~ ~ ~ ~ ~ ~ //

    // Add a new bank node
    function addNode(string memory name, bytes32 publicKey) public {
        bankNodes[publicKey] = BankNode(name, new address[](0), publicKey);
    }

    // Add a new account to a bank node
    function addAccount(bytes32 publicKey, address account) public {
        bankNodes[publicKey].accounts.push(account);
    }

    // ~ ~ ~ ~ ~ ~ ~ UPDATE Methods ~ ~ ~ ~ ~ ~ ~ //

    // Update the name of a bank node
    function updateNodeName(bytes32 publicKey, string memory name) public {
        bankNodes[publicKey].name = name;
    }

    // Update the public key of a bank node
    function updateNodePublicKey(bytes32 oldPublicKey, bytes32 newPublicKey) public {
        BankNode storage node = bankNodes[oldPublicKey];
        node.publicKey = newPublicKey;
        bankNodes[newPublicKey] = node;
        delete bankNodes[oldPublicKey];
    }

    // ~ ~ ~ ~ ~ ~ ~ REMOVE Methods ~ ~ ~ ~ ~ ~ ~ //

    // Remove a bank node
    function removeNode(bytes32 publicKey) public {
        delete bankNodes[publicKey];
    }

    // Remove an account from a bank node
    function removeAccount(bytes32 publicKey, address account) public {
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

}