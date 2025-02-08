pragma solidity ^0.8.20;

contract Voting {
    struct Voter {
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted proposal
    }

    struct Proposal {
        bytes32 name; // short name
        uint voteCount; // number of accumulated votes
    }

    //address of the owner
    address public owner;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor(bytes32[] memory proposalName) {
        owner = msg.sender;

        for (uint i = 0; i < proposalName.length; i++){
            proposals.push(Proposal(proposalName[i], 0));
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You have already voted");
        require(proposal < proposals.length, "Invalid proposal");

        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += 1;
    }
}