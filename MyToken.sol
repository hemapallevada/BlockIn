pragma solidity ^0.6;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
contract MyToken is  ERC20 {
    address public minter;
    constructor()ERC20("Mytoken","$") public{
       _mint(msg.sender,21000000);
       minter=msg.sender;
     
    }
  function getMinter() public view returns(address){
  return minter;
  }
    
     
}
