// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// Import necessary OpenZeppelin contracts for security and standard implementations
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "./InterbankRegistry.sol";

contract InterbankTransactionManager is ReentrancyGuard {
    // Struct to define a transaction
    struct Transaction {
        address sender;
        address receiver;
        string sourceCurrency;
        string targetCurrency;
        uint256 sourceAmount;
        uint256 convertedAmount;
        uint256 timestamp;
        TransactionStatus status;
    }
    
    // Enum for transaction status
    enum TransactionStatus { 
        Initiated, 
        SourceConverted, 
        Transferred, 
        Completed, 
        Failed 
    }
    
    // EURC token contract
    IERC20 public eurcToken;
    
    // Price oracle for currency conversions
    address public priceOracle;
    
    // Registry of financial institutions
    InterbankRegistry public institutionRegistry;
    
    // Mapping of transactions
    mapping(bytes32 => Transaction) public transactions;
    
    // Events for transaction tracking
    event TransactionInitiated(
        bytes32 indexed transactionId, 
        address indexed sender, 
        address indexed receiver, 
        string sourceCurrency, 
        string targetCurrency, 
        uint256 sourceAmount
    );
    event TransactionConverted(
        bytes32 indexed transactionId, 
        uint256 eurcAmount
    );
    event TransactionTransferred(
        bytes32 indexed transactionId, 
        uint256 finalAmount
    );
    
    /**
     * @notice Constructor to set up the transaction manager
     * @param _eurcTokenAddress Address of the EURC token
     * @param _priceOracle Address of the price oracle
     * @param _institutionRegistry Address of the institution registry
     */
    constructor(
        address _eurcTokenAddress, 
        address _priceOracle, 
        address _institutionRegistry
    ) {
        eurcToken = IERC20(_eurcTokenAddress);
        priceOracle = _priceOracle;
        institutionRegistry = InterbankRegistry(_institutionRegistry);
    }
    
    /**
     * @notice Initiate a cross-border transaction
     * @param _receiver Receiving institution address
     * @param _sourceCurrency Source currency code
     * @param _targetCurrency Target currency code
     * @param _sourceAmount Amount to transfer
     * @return Transaction ID
     */
    function initiateTransaction(
        address _receiver, 
        string memory _sourceCurrency, 
        string memory _targetCurrency, 
        uint256 _sourceAmount
    ) external nonReentrant returns (bytes32) {
        // Validate transaction parameters
        require(_receiver != address(0), "Invalid receiver");
        require(_sourceAmount > 0, "Amount must be positive");
        
        // Generate unique transaction ID
        bytes32 transactionId = keccak256(abi.encodePacked(
            msg.sender, 
            _receiver, 
            _sourceCurrency, 
            _targetCurrency, 
            _sourceAmount, 
            block.timestamp
        ));
        
        // Create transaction record
        transactions[transactionId] = Transaction({
            sender: msg.sender,
            receiver: _receiver,
            sourceCurrency: _sourceCurrency,
            targetCurrency: _targetCurrency,
            sourceAmount: _sourceAmount,
            convertedAmount: 0,
            timestamp: block.timestamp,
            status: TransactionStatus.Initiated
        });
        
        // Emit transaction initiation event
        emit TransactionInitiated(
            transactionId, 
            msg.sender, 
            _receiver, 
            _sourceCurrency, 
            _targetCurrency, 
            _sourceAmount
        );
        
        return transactionId;
    }
    
    /**
     * @notice Convert source currency to EURC
     * @param _transactionId Unique transaction identifier
     */
    function convertToEURC(bytes32 _transactionId) external {
        Transaction storage transaction = transactions[_transactionId];
        require(transaction.status == TransactionStatus.Initiated, "Invalid transaction stage");
        
        // Fetch conversion rate from price oracle
        uint256 conversionRate = fetchConversionRate(
            transaction.sourceCurrency, 
            "EURC"
        );
        
        // Calculate EURC amount
        uint256 eurcAmount = transaction.sourceAmount * conversionRate / 10**18;
        
        // Update transaction details
        transaction.convertedAmount = eurcAmount;
        transaction.status = TransactionStatus.SourceConverted;
        
        // Emit conversion event
        emit TransactionConverted(_transactionId, eurcAmount);
    }
    
    /**
     * @notice Transfer EURC to target currency
     * @param _transactionId Unique transaction identifier
     */
    function transferToTarget(bytes32 _transactionId) external {
        Transaction storage transaction = transactions[_transactionId];
        require(transaction.status == TransactionStatus.SourceConverted, "Invalid transaction stage");
        
        // Fetch conversion rate from price oracle
        uint256 conversionRate = fetchConversionRate(
            "EURC", 
            transaction.targetCurrency
        );
        
        // Calculate final amount in target currency
        uint256 finalAmount = transaction.convertedAmount * conversionRate / 10**18;
        
        // Update transaction status
        transaction.status = TransactionStatus.Transferred;
        
        // Emit transfer event
        emit TransactionTransferred(_transactionId, finalAmount);
    }
    
    /**
     * @notice Fetch conversion rate from price oracle
     * @param _sourceCurrency Source currency code
     * @param _targetCurrency Target currency code
     * @return Conversion rate
     */
    function fetchConversionRate(
        string memory _sourceCurrency, 
        string memory _targetCurrency
    ) internal view returns (uint256) {
        // Placeholder for price oracle interaction
        // In a real implementation, this would interact with an external oracle
        return 10**18; // 1:1 conversion for demonstration
    }
}