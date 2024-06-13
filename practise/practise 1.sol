// SPDX-License-Identifier: MIT



    
    
    
     pragma solidity ^0.8.0;


    contract vVting {
        // Structure to represent a candidate
        struct Candidate {
            string name;
            uint256 voteCount;
        }

        // Array of candidates
        Candidate[] public candidates;

        // Mapping to store whether a voter has already voted
        mapping(address => bool) public hasVoted;


        // Event to notify when a vote is cast
        event VoteCast(address indexed _voted, string _candidateName);

        // Constructor to initialize candidates
        constructor(string[] memory _candidateNames) {
            for (uint256 i = 0; i < _candidateNames.length; i++) {
                candidate.push(Candidate(_candidatedNames[i], 0));
            }
        } 

        // function to cast a vote

        function vote(uint256 _candidateIndex) external {
            require(!hasVoted[msg.sender], "You have already voted.");
            require(_candidateIndex < candidates.length, "Invalid candidate index.");
        }

        // Increment vote count for the chosen candidate
        candidates[_candidateIndex],voteCount++;

        // Mark the voter as having voted
        hasvoted[msg.sender] = true;

        // Emit event
        emit Votecast(msgg.sender, candidates[_candidateIndex].name);

    }

    //Function to get the winner
    function getWinner() external view returns(string memory) {
        require(candidates.length > 0, "No candidates available.")

        uint256 maxVotes = 0;
        uint256 winnigCandidateIndex = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].votecount > maxVotes) {
                maxVotes = candidates[i].voteount;
                winningCandidateIndex = 1;
            }
        }

        return cadidates[winnigCandidateIndex].name;

    }
