const CAP = 100;
const NAME = "Silver Mare Coin Digital Certificate of Authenticity";
const SIGNER = "0x00Ad9AEb02CC7892c94DBd9E9BE93Ec5cf644632"; // marebits.eth
const SYMBOL = "🐎🪙📜 A‍g M‍A‍R‍E 2‍0‍2‍2";

const MetadataBuilder = artifacts.require("MetadataBuilder");
const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");
const SilverMareCoinForwarder = artifacts.require("SilverMareCoinForwarder");
const SilverMareCoinPaymaster = artifacts.require("SilverMareCoinPaymaster");

async function deploySilverMareCoin(deployer) {
	const DEPLOYED = {};
	await deployer.deploy(MetadataBuilder);
	deployer.link(MetadataBuilder, SilverMareCoinDCoA);
	await deployer.deploy(SilverMareCoinForwarder);
	DEPLOYED.SilverMareCoinForwarder = await SilverMareCoinForwarder.deployed();
	await deployer.deploy(SilverMareCoinDCoA, NAME, SYMBOL, CAP, SIGNER, DEPLOYED.SilverMareCoinForwarder.address);
	DEPLOYED.SilverMareCoinDCoA = await SilverMareCoinDCoA.deployed();
	deployer.deploy(SilverMareCoinPaymaster, DEPLOYED.SilverMareCoinForwarder.address, DEPLOYED.SilverMareCoinDCoA.address);
}

module.exports = deploySilverMareCoin;