import dotenv from "dotenv";
dotenv.config(); // Load environment variables from .env file
const { ethers } = require('hardhat');
const { abi } = require('./artifacts/contracts/EsportsTournament.sol/EsportsTournament.json'); // Replace with the correct path to your contract's ABI JSON

async function main() {
  const contractAddress = '<deployed-contract-address>';
  const provider = new ethers.providers.JsonRpcProvider();
  const contract = new ethers.Contract(contractAddress, abi, provider);

  // Call contract methods here
  const registrationFee = await contract.registrationFee();
  console.log('Registration Fee:', registrationFee.toString());

  const numberOfPlayers = await contract.numberOfPlayers();
  console.log('Number of Players:', numberOfPlayers.toNumber());

  const playerInfo = await contract.players(1); // Assuming player with ID 1
  console.log('Player Info:', playerInfo);

  const matchInfo = await contract.matches(1); // Assuming match with ID 1
  console.log('Match Info:', matchInfo);

  // Call other contract methods and perform interactions
}

main().catch(error => {
  console.error(error);
  process.exit(1);
});

