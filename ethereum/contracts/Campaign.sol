pragma solidity ^0.4.17;

contract CampaignFactory{
    address[] public deployedCampaign;
     function createCampaign(uint minimum) public{
         address newCampaign=new Campaign(minimum,msg.sender);
         deployedCampaign.push(newCampaign);
     }
     function getDeployedCampaign() public view returns(address[]){
         return deployedCampaign;
     }
}

contract Campaign{
    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping (address=>bool) approvals;
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address=>bool) public approvers;
    uint public approversCount;
    
    modifier restricted(){
        require(msg.sender==manager);
        _;
    }
    function Campaign(uint minimum,address creator) public{
        manager=creator;
        minimumContribution=minimum;
    }
    function contribute() public payable{
        require(msg.value>minimumContribution);
        approvers[msg.sender]=true;
        approversCount++;
    }
    function createRequest(string description,uint value,address recipient) public restricted{
        Request memory newRequest= Request({
            description:description,
            value:value,
            recipient:recipient,
            complete:false,
            approvalCount:0
        });
        requests.push(newRequest);
    }
    function approveRequest(uint index) public{
        require(approvers[msg.sender]);
        require(!requests[index].approvals[msg.sender]);
        requests[index].approvals[msg.sender]=true;
        requests[index].approvalCount++;
    }
    function finalizeRequest(uint index) public restricted{
        Request storage request=requests[index];
        require(!request.complete);
        require(request.approvalCount>(approversCount/2));
        request.recipient.transfer(request.value);
        request.complete=true;
    }
    function getSummary() public view returns(uint,uint,uint,uint,address){
        return(
            minimumContribution,
            address(this).balance,
            requests.length,
            approversCount,
            manager
        );
    }
    function getRequestsCount() public view returns(uint){
        return requests.length;
    }
}