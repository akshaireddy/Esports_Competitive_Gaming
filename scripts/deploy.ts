const { ethers, upgrades } = require('hardhat');

async function main() {
  const EsportsTournament = await ethers.getContractFactory('EsportsTournament');
  
  // Provide constructor arguments here if required
  const constructorArgs = [
    ethers.utils.parseEther("0.1"),  // Registration fee (in Ether)
    ethers.utils.parseEther("100.0") // Total prize pool (in Ether)
  ];
  
  // Deploy the contract as an upgradeable proxy
  const contract = await upgrades.deployProxy(EsportsTournament, constructorArgs);

  await contract.deployed();

  console.log('Contract deployed to:', contract.address);
}

main().catch(error => {
  console.error(error);
  process.exit(1);
});
