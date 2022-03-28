const MetadataBuilder = artifacts.require("MetadataBuilder");
const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");
const SilverMareCoinForwarder = artifacts.require("SilverMareCoinForwarder");
const SilverMareCoinPaymaster = artifacts.require("SilverMareCoinPaymaster");
const SIGNERS = {
	development: "0xbaeb3bd505b6674bf44ede0f00e86c7172b40b39", 
	ganache: "0x889976c9BB7078F5538A7c8A07a5A303A394C251", 
	mumbai: "0x889976c9BB7078F5538A7c8A07a5A303A394C251", 
	polygon: "0x00Ad9AEb02CC7892c94DBd9E9BE93Ec5cf644632"
};
SIGNERS.develop = SIGNERS.development;

async function deploySilverMareCoin(deployer) {
	const DEPLOYED = {};
	await deployer.deploy(MetadataBuilder);
	deployer.link(MetadataBuilder, SilverMareCoinDCoA);
	await deployer.deploy(SilverMareCoinForwarder);
	DEPLOYED.SilverMareCoinForwarder = await SilverMareCoinForwarder.deployed();
	await deployer.deploy(SilverMareCoinDCoA, SIGNERS[deployer.network], DEPLOYED.SilverMareCoinForwarder.address);
	DEPLOYED.SilverMareCoinDCoA = await SilverMareCoinDCoA.deployed();
	await deployer.deploy(SilverMareCoinPaymaster, DEPLOYED.SilverMareCoinForwarder.address, DEPLOYED.SilverMareCoinDCoA.address);
}

module.exports = deploySilverMareCoin;