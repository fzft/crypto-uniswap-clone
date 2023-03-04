const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const {ethers, waffle} = require('hardhat');
const LibArtifact = require('../artifacts/contracts/libraries/LiqudityMath.sol/LiquidityMath.json');
const {deployContract} = waffle;

describe("Liquidity Math library", function () {

  async function deployOnceFixture() {

    const [owner, ...otherAccounts] = await ethers.getSigners();
    lib = (await deployContract(owner, LibArtifact));
    return { lib, owner, otherAccounts };
  }
  describe("Testing test()", function () {
    it("how much of USDC I need when providing 2 ETH at this price and range ?", async function () {
      const { lib } = await loadFixture(deployOnceFixture); 
      let p = 2000;
      let a = 1500;
      let b = 2500;
      let x = 2;
      
      let sqrtP = p **0.5;
      let sqrtA = a **0.5;
      let sqrtB = b **0.5;
      const l = await lib.getLiquidityForY(x, sqrtP, sqrtB);
      const y = await lib.calculateY(l, sqrtP, sqrtA, sqrtB);
      console.log("amount of USDC y:", y);
    });
  });

    
});
