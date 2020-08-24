pragma solidity ^0.6;
contract company{
    
    constructor()public{
      
    }
struct Company{
   
    address CompanyId;
    string CompanyName;
    }

mapping(address=> Company) AllCompanies;
mapping(address=> uint) AvailableCompanies;
mapping(string=> Company) NameToAddress;

function onCompanySignUp(string memory CompanyName ) public{
    address temp_add=getAddressByName(CompanyName);
    require(isCompany(temp_add)!=true,"Company With Same Name Already Exists");
    Company memory cur_company;
   
    cur_company.CompanyName=CompanyName;
    cur_company.CompanyId=msg.sender;
    AllCompanies[msg.sender]=cur_company;
    NameToAddress[CompanyName]=cur_company;
    AvailableCompanies[msg.sender]=1;
    
}

function isCompany(address add) public view returns(bool){
    if(AvailableCompanies[add]==0){
        return false;
    }return true;
}
function getAddressByName(string memory name) public view returns(address ){
   return NameToAddress[name].CompanyId;
}
function getCompany(address id) public view returns(string memory){

return AllCompanies[id].CompanyName;
}
}
