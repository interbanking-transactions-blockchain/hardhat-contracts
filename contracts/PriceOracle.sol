// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// Import necessary OpenZeppelin contracts for security and standard implementations
import "@openzeppelin/contracts/access/Ownable.sol";

contract PriceOracle is Ownable {

    constructor(address _initialOwner) Ownable(_initialOwner) {
        // Optional: additional initialization if needed
    }

    // Mapping of currency pair to conversion rate
    mapping(string => mapping(string => uint256)) public conversionRates;
    
    // Event for rate updates
    event RateUpdated(string sourceCurrency, string targetCurrency, uint256 rate);
    
    /**
     * @notice Update conversion rate for a currency pair
     * @param _sourceCurrency Source currency code
     * @param _targetCurrency Target currency code
     * @param _rate Conversion rate
     */
    function updateRate(
        string memory _sourceCurrency, 
        string memory _targetCurrency, 
        uint256 _rate
    ) external onlyOwner {
        conversionRates[_sourceCurrency][_targetCurrency] = _rate;
        emit RateUpdated(_sourceCurrency, _targetCurrency, _rate);
    }
    
    /**
     * @notice Get conversion rate for a currency pair
     * @param _sourceCurrency Source currency code
     * @param _targetCurrency Target currency code
     * @return Conversion rate
     */
    function getRate(
        string memory _sourceCurrency, 
        string memory _targetCurrency
    ) external view returns (uint256) {
        return conversionRates[_sourceCurrency][_targetCurrency];
    }
}