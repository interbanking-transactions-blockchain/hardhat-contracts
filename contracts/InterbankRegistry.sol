// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// Import necessary OpenZeppelin contracts for security and standard implementations
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InterbankRegistry is Ownable {

    constructor(address _initialOwner) Ownable(_initialOwner) {
        // Optional: additional initialization if needed
    }

    // Enum to define institution types
    enum InstitutionType { Bank, FinancialInstitution, CentralBank }
    
    // Struct to store institution details
    struct Institution {
        address institutionAddress;
        InstitutionType institutionType;
        bool isApproved;
        mapping(string => bool) supportedCurrencies;
    }
    
    // Mapping of registered institutions
    mapping(address => Institution) public institutions;
    
    // List of all registered institution addresses
    address[] public registeredInstitutions;
    
    // Events for tracking institution registration and updates
    event InstitutionRegistered(address indexed institutionAddress, InstitutionType institutionType);
    event InstitutionApproved(address indexed institutionAddress);
    event CurrencySupport(address indexed institutionAddress, string currency, bool supported);
    
    /**
     * @notice Register a new financial institution
     * @param _institutionAddress Address of the institution
     * @param _institutionType Type of institution
     */
    function registerInstitution(
        address _institutionAddress, 
        InstitutionType _institutionType
    ) external onlyOwner {
        require(_institutionAddress != address(0), "Invalid institution address");
        
        institutions[_institutionAddress].institutionAddress = _institutionAddress;
        institutions[_institutionAddress].institutionType = _institutionType;
        
        registeredInstitutions.push(_institutionAddress);
        
        emit InstitutionRegistered(_institutionAddress, _institutionType);
    }
    
    /**
     * @notice Approve a registered institution
     * @param _institutionAddress Address of the institution to approve
     */
    function approveInstitution(address _institutionAddress) external onlyOwner {
        institutions[_institutionAddress].isApproved = true;
        emit InstitutionApproved(_institutionAddress);
    }
    
    /**
     * @notice Add currency support for an institution
     * @param _institutionAddress Address of the institution
     * @param _currency Currency code (e.g., 'USD', 'EUR')
     * @param _supported Whether the currency is supported
     */
    function addCurrencySupport(
        address _institutionAddress, 
        string memory _currency, 
        bool _supported
    ) external onlyOwner {
        institutions[_institutionAddress].supportedCurrencies[_currency] = _supported;
        emit CurrencySupport(_institutionAddress, _currency, _supported);
    }
}