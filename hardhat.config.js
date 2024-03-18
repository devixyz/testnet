/*
 * @Description:
 * @Author: Devin
 * @Date: 2024-03-18 13:03:40
 */
require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  paths: {
    artifacts: "./src",
  },
  networks: {
    merlinTestnet: {
      url: `https://testnet-rpc.merlinchain.io`,
      accounts: [
        "0x696b0d8593cbb3932dfc8377e15ea2b32a08ce30637f0a791719ae42aadb7a22",
      ],
    },
  },
};
