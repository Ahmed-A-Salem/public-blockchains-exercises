require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: "../.env" });
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  defaultNetwork: "unima",
  networks: {
    unima: {
      url: process.env.UNIMA_RPC_URL,
      accounts: [process.env.METAMASK_1_PRIVATE_KEY],
    },
  },
};
