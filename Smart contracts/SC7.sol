



// SPDX-License-Identifier: MIT


pragma solidity  ^0.8.25;


contract DAO {

    struct Proposal {
        uint id;
        string description;
        uint budget;
        uint deadline;
        uint yeaVotes;
        uint nayVotes;
        bool executed;
    }

    mapping(uint => Proposal) public proposals;

    mapping(address => bool) public hasVoted;

    string public name;
    uint public votingPeriod;

    event Voted(uint proposalId, address member, bool vote);

    event ProposalExecuted(uint proposalId);

    function createDAO(string memory daoName, uint votingDuration) public{
        name = daoName;
        votingPeriod = votingDuration;
    }

    function vote(uint proposalId, bool voteChoice) public {
        require(!hasVoted[msg.sender], "Already voted on this proposal");
        require(block.timestamp < proposals[proposalId].deadline, "Voting deadline has passed");
        hasVoted[msg.sender] = true;
        if (voteChoice) {
            proposals[proposalId].yeaVotes++;
        } else {
            proposals[proposalId].nayVotes++;
        }
        emit Voted(proposalId, msg.sender,voteChoice);
    }

    function executeProposal(uint proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp > proposal.deadline, "Voting still ongoing");
        require(!proposal.executed, "Proposal already executed");
        require(proposal.yeaVotes > proposal.nayVotes, "Proposal not approved");
        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }

}