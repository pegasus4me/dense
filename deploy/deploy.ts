import { ethers } from "hardhat";

async function main() {
  const Dense = await ethers.deployContract("CrowdFunding");
  await Dense.waitForDeployment();
  const DenseContract  = await Dense.getAddress()
} 
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
