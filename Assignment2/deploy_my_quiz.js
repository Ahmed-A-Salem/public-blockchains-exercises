const hre = require("hardhat");

async function main() {
    const questions = [
        "Are Rachel and Phoebe siblings?",
        "Did Rachel write and perform the song 'Smelly Cat'?",
        "Does Chandler work in data processing?",
        "Is Rachel's first job in fashion?",
        "Did Ross say the correct name at his wedding in London?"
    ];
  const answers = [false, false, true, false, false];

  const MyQuiz = await hre.ethers.getContractFactory("MyQuiz");
  const myQuiz = await MyQuiz.deploy(questions, answers);

  await myQuiz.waitForDeployment();
  console.log(`✅ Contract deployed at: ${await myQuiz.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});