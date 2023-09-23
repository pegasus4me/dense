"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const hardhat_1 = require("hardhat");
async function main() {
    const Dense = await hardhat_1.ethers.deployContract("CrowdFunding");
    await Dense.waitForDeployment();
    const DenseContract = await Dense.getAddress();
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
