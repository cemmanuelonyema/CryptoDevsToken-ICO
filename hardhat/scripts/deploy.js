const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const {CRYPTO_DEVS_NFT_CONTRACT_ADDRESS} = require("../constants");

async function main() {
  // Address of the crypto devs nft contract  deployed  previously
  const cryptoDevsNftContract = CRYPRO_DEV_NFT_CONTRACT_ADDRESS;

  /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so cryptoDevsContract here is a factory for instances of our CryptoDevs contract.
  */
  const cryptoDevsTokenContract = await ethers.getContractFactory("CryptoDevsToken");

  // deploy the contract
  const deployedCryptoDevsTokenContract = await cryptoDevsTokenContract.deploy(
    ''CryptoDevsToken''
  );

  // print the address of the deployed contract
  console.log(
    "Deployed sucessfully: Crypto Devs Token Contract Address:",
    deployedCryptoDevsContract.address
  );
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
