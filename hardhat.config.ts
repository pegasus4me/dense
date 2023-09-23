import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv"
dotenv.config()

const config: HardhatUserConfig = {
  
  solidity: "0.8.19",
  networks : {
    
    arbitrumGoerli: {
      url: process.env.PROVIDER_KEY_URL as string | undefined,
      chainId: 421613,
      accounts: [process.env.PRIVATE_KEY as string]
    },
  
  },
  etherscan :  {
    apiKey : process.env.APYV2AYS7UMRVW3XAF9NK5XM72DPIQSAUV
  }
};

export default config;
