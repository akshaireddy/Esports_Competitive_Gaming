// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EsportsTournament {
    address public owner;
    uint256 public registrationFee;
    uint256 public totalPrizePool;
    uint256 public numberOfPlayers;
    enum MatchResult { NotPlayed, Team1Wins, Team2Wins, Draw }
    
    struct Player {
        address playerAddress;
        string playerName;
        uint256 teamId;
        bool registered;
    }
    
    struct Match {
        uint256 matchId;
        uint256 team1Id;
        uint256 team2Id;
        uint256 matchDate;
        MatchResult result;
        bool resolved;
    }
    
    mapping(uint256 => Player) public players;
    mapping(uint256 => Match) public matches;
    
    event PlayerRegistered(address indexed playerAddress, string playerName, uint256 teamId);
    event MatchOutcome(uint256 indexed matchId, MatchResult result);
    event PrizeDistributed(address indexed winner, uint256 amount);
    
    constructor(uint256 _registrationFee) {
        owner = msg.sender;
        registrationFee = _registrationFee;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }
    
    function registerPlayer(string memory _playerName, uint256 _teamId) external payable {
        require(msg.value == registrationFee, "Registration fee is required");
        require(!players[_teamId].registered, "Player already registered in this team");
        
        players[_teamId] = Player(msg.sender, _playerName, _teamId, true);
        numberOfPlayers++;
        
        emit PlayerRegistered(msg.sender, _playerName, _teamId);
    }
    
    function createMatch(uint256 _team1Id, uint256 _team2Id, uint256 _matchDate) external onlyOwner {
        uint256 matchId = numberOfPlayers + 1; // Simple way to generate unique match IDs
        matches[matchId] = Match(matchId, _team1Id, _team2Id, _matchDate, MatchResult.NotPlayed, false);
    }
    
    function resolveMatch(uint256 _matchId, MatchResult _result) external onlyOwner {
        require(matches[_matchId].matchId == _matchId, "Match does not exist");
        require(matches[_matchId].resolved == false, "Match result already resolved");
        
        matches[_matchId].result = _result;
        matches[_matchId].resolved = true;
        
        if (_result == MatchResult.Team1Wins) {
            distributePrize(players[matches[_matchId].team1Id].playerAddress, totalPrizePool / 2);
        } else if (_result == MatchResult.Team2Wins) {
            distributePrize(players[matches[_matchId].team2Id].playerAddress, totalPrizePool / 2);
        } else if (_result == MatchResult.Draw) {
            distributePrize(players[matches[_matchId].team1Id].playerAddress, totalPrizePool / 2);
            distributePrize(players[matches[_matchId].team2Id].playerAddress, totalPrizePool / 2);
        }
        
        emit MatchOutcome(_matchId, _result);
    }
    
    function distributePrize(address _winner, uint256 _amount) internal {
        totalPrizePool -= _amount;
        payable(_winner).transfer(_amount);
        emit PrizeDistributed(_winner, _amount);
    }
}
