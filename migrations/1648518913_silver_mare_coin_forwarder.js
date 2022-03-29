const SilverMareCoinForwarder = artifacts.require("SilverMareCoinForwarder");

async function deploySilverMareCoinForwarder(deployer) {
	await deployer.deploy(SilverMareCoinForwarder);
}

module.exports = deploySilverMareCoinForwarder;