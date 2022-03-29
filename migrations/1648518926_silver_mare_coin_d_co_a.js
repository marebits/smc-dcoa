const SIGNERS = require("../scripts/signers.js");
const utils = require("../scripts/utils.js");

const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");
const SilverMareCoinForwarder = artifacts.require("SilverMareCoinForwarder");

async function deploySilverMareCoinDCoA(deployer) {
	const silverMareCoinForwarder = await SilverMareCoinForwarder.deployed();
	await deployer.deploy(SilverMareCoinDCoA, SIGNERS[await utils.getNetworkName(config)], silverMareCoinForwarder.address);
}

module.exports = deploySilverMareCoinDCoA;