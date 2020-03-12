pragma solidity >=0.4.21;

contract TokenRegistry {

    address public owner;
    address public rollupNC;

    mapping(address => bool) public pendingRegistrations;
    mapping(uint256 => address) public registeredTokens;

    uint256 public numTokens;

    modifier fromRollup{
        assert(msg.sender == rollupNC);
        _;
    }

    modifier onlyOwner(){
        assert(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
        numTokens = 1; //ETH
    }

    function setRollupAddress(
        address _rollupNC
    ) public onlyOwner {
        rollupNC = _rollupNC;
    }

    function requestTokenRegistration(
        address tokenContract
    ) public {
        require(pendingRegistrations[tokenContract] == false, "Token already registered.");
        pendingRegistrations[tokenContract] = true;
    }

    function finaliseTokenRegistration(
        address tokenContract
    ) public fromRollup {
        require(pendingRegistrations[tokenContract], 'Token was not registered');
        numTokens++;
        registeredTokens[numTokens] = tokenContract; // tokenType => token contract address
    }

}