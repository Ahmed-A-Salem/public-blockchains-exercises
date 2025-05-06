const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  // ✅ This MUST match what the Dapp expects
  const validator = "0x8452E41BA34aC00458B70539264776b2a379448f";

  // Get contract factory
  const Token = await hre.ethers.getContractFactory("CensorableToken");

  // ✅ Correct parameter order: owner first, then validator
  const token = await Token.deploy(deployer.address, validator);

  // Wait for deployment to finish
  await token.waitForDeployment();

  console.log(`✅ Token deployed to: ${token.target}`);
  console.log(`Deployer (owner): ${deployer.address}`);
  console.log(`Validator: ${validator}`);
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});
