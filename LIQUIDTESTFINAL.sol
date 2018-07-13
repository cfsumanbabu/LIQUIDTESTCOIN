pragma solidity ^0.4.23;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert() on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
    constructor() public {
        owner = msg.sender;
    }

  /**
   * @dev Throws if called by any account other than the owner.
   */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
    function transferOwnership(address _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
    function _transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0x0));
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

/**
 * @title ERC20 interface
 */
contract AbstractERC20 {
    uint256 public totalSupply;
    function balanceOf(address _owner) public constant returns (uint256 value);
    function transfer(address _to, uint256 _value) public returns (bool _success);
    function allowance(address owner, address spender) public constant returns (uint256 _value);
    function transferFrom(address from, address to, uint256 value) public returns (bool _success);
    function approve(address spender, uint256 value) public returns (bool _success);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}

contract LQCoin4 is Ownable, AbstractERC20 {
    
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;
    
    uint public  presaleStartDate ;
    uint public  presaleEndDate ;
    uint public  presaleSoftCap ;
    uint public  presaleHardCap ;
    
    uint public  ITOstartdate ;
    uint public  ITOenddate ;
    uint public  ITOSoftCap ;
    uint public  ITOHardCap ;
    
    uint public  TOKENS_TOTAL ;
    uint public  tokensPerPreSaleKEther ;
    uint public  tokensPerICOEther ;

    uint public CONTRIBUTIONS_MIN = 0.0015541786683797 ether ;
    uint public CONTRIBUTIONS_MAX = 10 ether;

mapping (address => uint256) internal balances;
     /// The transfer allowances
mapping (address => mapping (address => uint256)) internal allowed;

mapping(address => bool) whitelist;
constructor() public {
    
    name = "LQCoin4";
    symbol = "LQCoin4";
    decimals = 18 ;
    totalSupply = 40e6 * 10**18;    // 40 million tokens
       
//  Price in USD  482.57 
//ETH per token = .75 / 482.57  = 0.0015541786683797
//This is the same as 1 / 0.0015541786683797 = 643.4266666666737 LIQUID per ETH
//tokensPerEther = 643.4266666666737
//tokensPerKEther = 643426

    tokensPerPreSaleKEther = 643426;
        
//  Price in USD  482.57 
//ETH per token = 1.40 / 482.57  =0.0029011335143088
//This is the same as 1 / 0.0029011335143088 = 344.6928571428577 LIQUID per ETH
//tokensPerICOEther = 344.6928571428577
//tokensPerICOEther = 344692

    tokensPerICOEther = 344692;
 // ------------------------------------------------------------------------
// PreSale soft cap and hard cap
// ------------------------------------------------------------------------
    presaleSoftCap = 4e6 * 10**18;
    presaleHardCap = 12e6 * 10**18;
// ------------------------------------------------------------------------
// Presale start date and end date
// Start - 07/04/2018 @ 1:59pm (UTC)
// End - 05/14/2018 @ 12:00am (UTC)
// ------------------------------------------------------------------------
    presaleStartDate = 1530712699;
    presaleEndDate = 1526256000;
 // ------------------------------------------------------------------------
// ITO soft cap and hard cap
// ------------------------------------------------------------------------
    ITOSoftCap =6e6 * 10**18;
    ITOHardCap = 18e6 * 10**18;
// ------------------------------------------------------------------------
// ITO  start date and end date
// Start - 07/04/2018 @ 1:59pm (UTC)
// End - 05/14/2018 @ 12:00am (UTC)
 // ------------------------------------------------------------------------
    ITOstartdate = 1530712699;
    ITOenddate = 1526256000;

    owner = msg.sender;
    balances[owner] = totalSupply;
    
    emit Transfer(0x0, owner, totalSupply);
     
    }



    /**
    * @dev Check balance of given account address
    * @param owner The address account whose balance you want to know
    * @return balance of the account
    */
    function balanceOf(address owner) public view returns (uint256){
        return balances[owner];
    }

    /**
    * @dev transfer token for a specified address (written due to backward compatibility)
    * @param to address to which token is transferred
    * @param value amount of tokens to transfer
    * return bool true=> transfer is succesful
    */
    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0x0));
        require(value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param from address from which token is transferred 
    * @param to address to which token is transferred
    * @param value amount of tokens to transfer
    * @return bool true=> transfer is succesful
    */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0x0));
        require(value <= balances[from]);
        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
     
        emit Transfer(from, to, value);
        return true;
    }
    
function approve(address addr) public {
    // owner approves buyers by address when they pass the whitelisting procedure
    require(msg.sender == owner);

    whitelist[addr] = true;
}
/* Fallback */
  
 
  
  
  function ()  public payable {
    uint ts ;
    ts= now;
    uint tokens = 0;
    // only approved buyers can call this function
    require(whitelist[msg.sender]);
     // No contributions before the start of the crowdsale
    require(now >= presaleStartDate);
    // No contributions after the end of the crowdsale
    require(now <= ITOenddate);
    
    // No contributions below the minimum (can be 0 ETH)
    require(msg.value >= CONTRIBUTIONS_MIN);
       
    // No contributions above a maximum (if maximum is set to non-0)
    require(CONTRIBUTIONS_MAX == 0 || msg.value < CONTRIBUTIONS_MAX);
      
    uint Bonustokens ;
    Bonustokens = GetBouns(msg.value);
      
      if (now > presaleStartDate && now < presaleEndDate){
          
            // Check if the pressale hard cap will be exceeded
            require(totalSupply + tokens + Bonustokens <= presaleHardCap);
            tokens = msg.value * tokensPerPreSaleKEther / 10**uint(18 - decimals + 3);
              
             
        }
        
        if(now > ITOstartdate && now < ITOenddate){
            
            if(now==ITOstartdate)
            {
                tokens = msg.value * tokensPerICOEther / 10**uint(18 - decimals + 3);
                tokens = tokens + tokens.mul(100 + 15) / 100;
                   
            }else if(now==ITOstartdate+1)
            {
                tokens = msg.value * tokensPerICOEther / 10**uint(18 - decimals + 3);
                tokens = tokens + tokens.mul(100 + 10) / 100;
                
            }else if(now==ITOstartdate+2)
            {
                tokens = msg.value * tokensPerICOEther / 10**uint(18 - decimals + 3);
                tokens = tokens + tokens.mul(100 + 5) / 100;
            }
            else
            {
            
            tokens = msg.value * tokensPerICOEther / 10**uint(18 - decimals + 3);
            }
            // Check if the ITO hard cap will be exceeded
            require(totalSupply + tokens + Bonustokens <= ITOHardCap);  
            
        }

   
    
    // Check if the hard cap will be exceeded
    // if (totalSupply + tokens > presaleHardCap) revert();
    // Add tokens purchased to account's balance and total supply
        
    totalSupply = totalSupply.add(tokens+Bonustokens);
    
    // register tokens
    balances[msg.sender]    = balances[msg.sender].add(tokens+Bonustokens);
    
    // log token issuance
    emit Transfer(0x0, msg.sender, tokens+Bonustokens);
   

  }
 function GetBouns(uint256 amount) internal pure returns (uint) {
     uint Bonustokens=0;
      //Bonus Available 50,000 5%; 
              if(amount == 5 ether){
                  
                  //  if(msg.value == 106.29703643862409 ether){
                   Bonustokens = Bonustokens.mul(100 + 5) / 100;
              }
             //Bonus Available  100,000 10%;
              if(amount== 212.59407287724818 ether){
                  
                  
                   Bonustokens = Bonustokens.mul(100 + 10) / 100;
              }
               //Bonus Available  200,000 15%
              if(amount == 425.18814575449636 ether){
                  
                  
                   Bonustokens = Bonustokens.mul(100 + 15) / 100;
              }
     
        return Bonustokens;
    }

    /**
    * @dev Approve function will delegate spender to spent tokens on msg.sender behalf
    * @param spender ddress which is delegated
    * @param value tokens amount which are delegated
    * @return bool true=> approve is succesful
    */
    function approve(address spender, uint256 value) public returns (bool) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev it will check amount of token delegated to spender by owner
    * @param owner the address which allows someone to spend fund on his behalf
    * @param spender address which is delegated
    * @return return uint256 amount of tokens left with delegator
    */
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowed[owner][spender];
    }

    /**
    * @dev increment the spender delegated tokens
    * @param spender address which is delegated
    * @param valueToAdd tokens amount to increment
    * @return bool true=> operation is succesful
    */
    function increaseApproval(address spender, uint valueToAdd) public returns (bool) {
        allowed[msg.sender][spender] = allowed[msg.sender][spender].add(valueToAdd);
        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev deccrement the spender delegated tokens
    * @param spender address which is delegated
    * @param valueToSubstract tokens amount to decrement
    * @return bool true=> operation is succesful
    */
    function decreaseApproval(address spender, uint valueToSubstract) public returns (bool) {
        uint oldValue = allowed[msg.sender][spender];
        if (valueToSubstract > oldValue) {
          allowed[msg.sender][spender] = 0;
        } else {
          allowed[msg.sender][spender] = oldValue.sub(valueToSubstract);
        }
        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }

}
