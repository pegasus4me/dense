import { ethers } from "hardhat";

async function main() {
  
  const Auth = await ethers.deployContract("Authentification");
  await Auth.waitForDeployment()
// ---------------------------------------------
  const Vault = await ethers.deployContract("Vault");
  await Vault.waitForDeployment()
//-----------------------------------------------
  const Dense = await ethers.deployContract("CrowdFunding", [await Auth.getAddress(), await Vault.getAddress()]);
  await Dense.waitForDeployment();
  console.log(`contract succesfully deployed in this contract =>${await Dense.getAddress()}`)
} 
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
