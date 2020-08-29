pragma solidity ^0.6;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
contract MyToken is  ERC20 {
    address public minter;
    constructor()ERC20("Mytoken","$") public{
       _mint(msg.sender,21000000);
       minter=msg.sender;
     
    }
    function buyTokens(address payable minter_add,uint tokens_to_purchase) payable public{
       uint amount_required=tokens_to_purchase*2;
        require(msg.value>=amount_required,"Please send enough money to buy tokens");
        uint spend=amount_required;
       
        minter_add.transfer(spend);
         
        transferFrom(minter,msg.sender,tokens_to_purchase);

    }
  function getMinter() public view returns(address){
  return minter;
  }
    
     
}
