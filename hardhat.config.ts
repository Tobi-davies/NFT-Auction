import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_URL,
      //@ts-ignore
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};

export default config;
