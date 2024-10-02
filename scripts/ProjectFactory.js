const hre = require("hardhat");

async function deploy() {
  const ProjectFactory = await hre.ethers.getContractFactory("ProjectFactory");
  const projectFactory = await ProjectFactory.deploy(
    "0x0d227d43Db18361c5c67f5a217673baD86787E67"
  );
  await projectFactory.waitForDeployment();
  console.log("ProjectFactory deployed at:", projectFactory.target);
}

deploy()
  .then(() => console.log("Deployment completed!"))
  .catch((error) => console.error("Error deploying contract:", error));
