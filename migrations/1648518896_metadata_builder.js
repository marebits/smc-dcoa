const MetadataBuilder = artifacts.require("MetadataBuilder");
const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");

async function deployMetadataBuilder(deployer) {
	await deployer.deploy(MetadataBuilder);
	deployer.link(MetadataBuilder, SilverMareCoinDCoA);
}

module.exports = deployMetadataBuilder;