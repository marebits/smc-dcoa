const ContractMetadataFile = require("../scripts/ContractMetadataFile.js");
const SIGNERS = require("../scripts/signers.js");
const TokenMetadataFiles = require("../scripts/TokenMetadataFiles.js");
const utils = require("../scripts/utils.js");

const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");
const SilverMareCoinForwarder = artifacts.require("SilverMareCoinForwarder");

const PROD_CAP = 100;
const DEV_CAP = 3;
const FLOOR = 1; // if this changes here, change it in the SilverMareCoinDCoA.sol contract as well; assuming this won't change
const SYMBOL = "🐎🪙📜 A‍g M‍A‍R‍E 2‍0‍2‍2";

async function deploySilverMareCoinDCoA(deployer, network) {
	const networkName = await utils.getNetworkName();
	const CAP = (networkName === "development") ? DEV_CAP : PROD_CAP;
	const contractMetadataFile = new ContractMetadataFile(CAP, SYMBOL);
	const tokenMetadataFiles = new TokenMetadataFiles(FLOOR, CAP);
	const [, silverMareCoinForwarder,] = await globalThis.Promise.all([
		contractMetadataFile.upload(), 
		SilverMareCoinForwarder.deployed(), 
		tokenMetadataFiles.uploadAll()
	]);
	await deployer.deploy(SilverMareCoinDCoA, CAP, contractMetadataFile.metadataUri, SIGNERS[networkName], SYMBOL, tokenMetadataFiles.metadataUri, silverMareCoinForwarder.address);
}

module.exports = deploySilverMareCoinDCoA;