const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  // Replace this with the real validator address before submission
  const validator = "0x766483FE15F19112d9f6069d05e4eA4d24C4eFA5"; // 🔁 Replace with actual validator if known

  const NFTMinter = await hre.ethers.getContractFactory("NFTminter_template");
  const minter = await NFTMinter.deploy(validator);
  await minter.waitForDeployment();

  console.log(`✅ NFTMinter deployed at: ${minter.target}`);
  console.log(`Deployer (owner): ${deployer.address}`);
  console.log(`Validator: ${validator}`);
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});
