import { ethers } from "hardhat";

async function main() {
  const Auction = await ethers.getContractFactory("Auction");
  const NFT = await ethers.getContractFactory("NFT");
  const auction = await Auction.deploy();
  const nft = await NFT.deploy();

  await auction.deployed();
  await nft.deployed();

  console.log(`Auction contract deployed to ${auction.address}`);
  console.log(`Nft contract deployed to ${nft.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// Auction contract deployed to 0x47d37940D15928a2c63812bC91f40DdC90e8cb8c

// Auction contract deployed to 0x7B197616AFe41ee2313a2B54CbD44e64213750BD
// NFT contract deployed to 0xD9Be56940cC4B88eeFcbC2B3b3Cf61d0aB1d7320
