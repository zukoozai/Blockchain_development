// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

    contract FreelanceMarketplace {

        struct Project {
            uint projectId;
            address client;
            address payable freelancer;
            string description;
            uint budget;
            uint deadline;
            bool completed;
        }

        mapping(uint => Project) public projects;

  
        event ProjectCreated(uint projectId, address client, address freelancer, string description, uint budget, uint deadline);
        
        function createProject(string memory _description, uint _deadline) public payable {

                uint projectId = 1;
            projects[projectId] = Project(
                projectId,
                msg.sender,
                payable(address(0)),
                _description,
                msg.value,
                _deadline,
                false
                );

            projectId++;

            emit ProjectCreated(projectId, msg.sender, payable(address(0)), _description, msg.value, _deadline);
  
        }


        function applyForProject(uint _projectId) public {
            Project storage project = projects[_projectId];
            require(!project.completed, "Project already completed");

            require(project.freelancer == payable(address(0)), "Freelancer already assigned");

            project.freelancer = payable(msg.sender);
        }

        function completeProject(uint _projectId) public {
        Project storage project = projects[_projectId];
        require(project.client == msg.sender, "Only client can mark project complete");

        require(project.freelancer != payable(address(0)), "No freelancer assigned");
        require(!project.completed, "Project already completed");

        project.completed = true;

        payable(project.freelancer).transfer(project.budget);
        }

    }