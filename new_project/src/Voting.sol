pragma solidity ^0.8.20;

contract Voting {
    struct Voter {
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted proposal
    }

    struct Proposal {
        string name; // short name
        uint voteCount; // number of accumulated votes
    }

    //address of the owner
    address public owner;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;
    uint256 public endTime;


    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor(string[] memory proposalName, uint256 _duration) {
        endTime = block.timestamp + (_duration * 1 hours);
        require(block.timestamp < endTime, "The vote is finish");
        require(_duration > 0, "The time must be positive");

        owner = msg.sender;

        for (uint i = 0; i < proposalName.length; i++){
            proposals.push(Proposal(proposalName[i], 0));
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) public {
        require(block.timestamp < endTime, "The vote is done, call GetWinner to see the results");
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You have already voted");
        require(proposal < proposals.length, "Invalid proposal");

        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += 1;
    }

    function getProposalLength() public view returns(uint256) {
        return proposals.length;
    }

    function getWinner() public view returns(string memory) {
        uint256 index = 0;

        for (uint256 i = 0; i < getProposalLength(); i++){
            if (proposals[i].voteCount > index)
                index = proposals[i].voteCount;
        }
        return proposals[index].name;
    }
}
