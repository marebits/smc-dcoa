const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");
const SilverMareCoinForwarder = artifacts.require("SilverMareCoinForwarder");
const SilverMareCoinPaymaster = artifacts.require("SilverMareCoinPaymaster");

async function deploySilverMareCoinPaymaster(deployer) {
	const silverMareCoinForwarder = await SilverMareCoinForwarder.deployed();
	const silverMareCoinDCoA = await SilverMareCoinDCoA.deployed();
	await deployer.deploy(SilverMareCoinPaymaster, silverMareCoinForwarder.address, silverMareCoinDCoA.address);
}

module.exports = deploySilverMareCoinPaymaster;