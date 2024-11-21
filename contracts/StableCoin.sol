// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// It needs openzeppelin 4.9.6 in order to work 
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract StableCoin is ERC20PresetMinterPauser{

    address private depositAccount;

    constructor(address _depositAccount) ERC20PresetMinterPauser("StableCoin", "SC"){
        require(_depositAccount != address(0), "Invalid account");
        depositAccount = _depositAccount;
        _setupRole(MINTER_ROLE, depositAccount);
        _mint(depositAccount, 1000000 * 10 ** 18);
    }

    function depositAndMint(address account, uint256 amount) external {
        require(account != address(0), "Invalid account");
        require(amount > 0, "Amount has to be greater than 0");
        _transfer(depositAccount, account, amount);
    }
}