const hre = require("hardhat");

async function deploy() {
  const Project = await hre.ethers.getContractFactory("Project");
  const project = await Project.deploy(
    "0x2fd977de3581eFD2c9155DcF02b7adbE3dD77327",
    "EU",
    1_000_000n
  );
  await project.waitForDeployment();
  console.log("Project deployed at:", project.target);
}

deploy()
  .then(() => console.log("Deployment completed!"))
  .catch((error) => console.error("Error deploying contract:", error));
