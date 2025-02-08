pragma solidity ^0.8.20;
import "../src/Voting.sol";
import "../lib/forge-std/src/Test.sol";


contract VotingTest is Test {
    Voting voting;
    string[] array = ["Donald Trump", "Kamala Haaris", "Ulysse Couchoud"];
    uint256 time = 13 hours;

    function setUp() public {
        voting = new Voting(array, time);
    }

    function testConstructor() public view {
        for (uint i = 0; i < voting.getProposalLength(); i++){
            (string memory proposalName, ) = voting.proposals(i);
            assertEq(proposalName, array[i], "Name is not the same");
        }
        assertEq(voting.endTime(), block.timestamp + time * 1 hours, "Time is not correct");
    }

    function testVote() public {
        voting.vote(0);
        (, uint256 voteCount) = voting.proposals(0);
        assertEq(voteCount, 1, "Vote didn't work");
        vm.expectRevert("You have already voted");
        voting.vote(0);
    }
}