pragma solidity ^0.6;
contract company{
    uint company_num;
    constructor()public{
        company_num=0;
    }
struct Company{
    uint CompanyNum;
    address CompanyId;
    string CompanyName;
    }

mapping(address=> Company) AllCompanies;
mapping(string=> Company) NameToAddress;

function onCompanySignUp(string memory CompanyName ) public{
    
    require(NameToAddress[CompanyName].CompanyNum!=0,"Company With Same Name Already Exists");
    Company memory cur_company;
    cur_company.CompanyNum=company_num+1;
    cur_company.CompanyName=CompanyName;
    cur_company.CompanyId=msg.sender;
    AllCompanies[msg.sender]=cur_company;
    NameToAddress[CompanyName]=cur_company;
    company_num+=1;
    
}

function getCompany(address id) public view returns(string memory){

return AllCompanies[id].CompanyName;
}
}
