pragma solidity ^0.6;
import "https://github.com/hemapallevada/BlockIn/blob/master/MyToken.sol" ;
import "https://github.com/hemapallevada/BlockIn/blob/master/Company.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/hemapallevada/BlockIn/blob/master/Employee.sol";
contract projectPost {
    address CompanyAddress;
    address TokenAddress;
    address EmployeeAddress;
    address minter ;
    uint no_of_posts;
     MyToken TokenObj;
     Company CompanyObj;
     Employee EmployeeObject;
     address owner;
   
    struct post{
        uint postId;
        uint no_of_available_posts;
        string roleName;
        uint Salary;
        string companyName;
        string qualificationRequired;
	mapping(address => address[]) referers;
        bool Status;
    } post cur_post;
    
mapping(uint => post) postAll;
   
    
  constructor() public{
   
   no_of_posts=0;
   instantiateContractMyToken(msg.sender);
   instantiateCompany(msg.sender);
   instantiateEmployee(msg.sender);
   minter=callMinter();
  }
 
  function instantiateContractMyToken(address Tokenobj) public{
TokenAddress=Tokenobj;  
TokenObj=MyToken(TokenAddress);
    }  
    function instantiateCompany(address Companyadd) public{
  CompanyAddress=Companyadd;
  CompanyObj=Company(CompanyAddress);
    }  
    function instantiateEmployee(address Empobj) public{
EmployeeAddress=Empobj;  
EmployeeObject=Employee(EmployeeAddress);
    }
    function callTransfer(address send,address received,uint am) payable public{
      TokenObj.approve(send,am+100);
        TokenObj.transferFrom(send,received,am);
    }
    function callMinter() public view returns(address){
       return TokenObj.getMinter();
    }
    
function postJob(string memory RoleName,uint salary,string memory qualificationRequired,uint number_of_available_posts) public{
        owner=msg.sender;
        string memory Company=CompanyObj.getCompanyName(msg.sender);
        uint cur_posts_no=no_of_posts+1;
        setPostId(cur_posts_no);
        setPostName(RoleName);
        setCompany(Company);
        setSalary(salary);
        setAvailablePosts(number_of_available_posts);
        setRequiredQualification(qualificationRequired);
       setStatus(false);
        uint totalAmount=TokenObj.balanceOf(owner);
        require(totalAmount>=(number_of_available_posts*1000),"No enough balance to post a project");
postAll[cur_post.postId]=cur_post;
TokenObj.approve(owner,number_of_available_posts*1000);
callTransfer(msg.sender,minter,number_of_available_posts*1000);
no_of_posts+=1;
    } 
    function setPostId(uint postId) private{
        cur_post.postId=postId;
    }
  
  function setPostName(string memory name) private{
        cur_post.roleName=name;
    }
    function setStatus(bool status) private{
        cur_post.Status=status;
    }
    function setSalary(uint salary) private{
        cur_post.Salary=salary;
    }
    function setAvailablePosts(uint AvailablePosts) private{
        cur_post.no_of_available_posts=AvailablePosts;
    }
     function setCompany(string memory company) private{
         cur_post.companyName=company;
     }
     function setRequiredQualification (string memory qualification) private{
         cur_post.qualificationRequired=qualification;
     }
     function addAReferer(address referer,address referee,uint id) public {
         require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
         require(EmployeeObject.getEmployeeCompanyId(referee)== id,"You should be an Employee of that company");
         postAll[id].referers[referer].push(referee);
     }
  function current_postId() public view returns(uint)  {
      return  cur_post.postId;
    }
  function  getRoleName() public view returns(string memory){
       return cur_post.roleName;
    }
    function getNoOfAvailablePosts() public view returns(uint){
    return   cur_post.no_of_available_posts;
    }
  function getotalPosts() public view returns(uint){
      return no_of_posts;
  }
  function getStatus() public view returns(bool){
      return cur_post.Status;
  }
   function  getRoleNameById(uint id) public view returns(string memory){
       require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
       return postAll[id].roleName;
    }
     function getNoOfAvailablePostsById(uint id) public view returns(uint){
         require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
    return postAll[id].no_of_available_posts;
    }
    function getStatusById(uint id) public view returns(bool){
        require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
      return postAll[id].Status;
  }
  
function getReferredPerson(uint postId,address selectedCan) public view returns (address[] memory){
    return postAll[postId].referers[selectedCan];
}
    function getSalary(uint postId) public view returns (uint){
        return postAll[postId].Salary;
        
    }
    function getCompany(uint postId) public view returns(string memory){
        return postAll[postId].companyName;
    } 
    
    function createDummyPosts(uint postId,string memory roleName,uint Salary,string memory companyName,string memory qualificationRequired,bool Status,uint no_of_available_posts)public{
    postAll[postId].postId=postId;
    postAll[postId].roleName=roleName;
    postAll[postId].Salary=Salary;
    postAll[postId].companyName=companyName;
    postAll[postId].qualificationRequired=qualificationRequired;
    postAll[postId].Status=Status;
    postAll[postId].no_of_available_posts=no_of_available_posts;
   /* uint postId;
        uint no_of_available_posts;
        string roleName;
        uint Salary;
        string companyName;
        string qualificationRequired;
	mapping(address => address[]) referers;
        bool Status;*/
    
}
function onCandidateSelect(address CandidateId,uint postId) public{
    uint totalReferers=getReferredPerson(postId,CandidateId).length;
    uint insAmount=1000/totalReferers;
    for(uint i=0;i<totalReferers;i++){
        callTransfer(minter,msg.sender,insAmount);
    }
}

}
