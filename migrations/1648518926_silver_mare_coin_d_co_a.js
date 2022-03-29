const fs = require("fs/promises");
const Migrations = artifacts.require("Migrations");
const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");
const SilverMareCoinForwarder = artifacts.require("SilverMareCoinForwarder");

const CAP = 100;
const CHAIN_IDS = { 1337: "ganache", 80001: "mumbai", 137: "polygon" };
const SIGNERS = {
	development: "0xbaeb3bd505b6674bf44ede0f00e86c7172b40b39", 
	ganache: "0x889976c9BB7078F5538A7c8A07a5A303A394C251", 
	mumbai: "0x889976c9BB7078F5538A7c8A07a5A303A394C251", 
	polygon: "0x00Ad9AEb02CC7892c94DBd9E9BE93Ec5cf644632"
};

const web3 = Migrations.interfaceAdapter.web3;
SIGNERS.develop = SIGNERS.development;

function asyncDelay(delayTimeMs) { return new Promise(resolve => setTimeout(resolve, delayTimeMs)); }

async function deploySilverMareCoinDCoA(deployer) {
	const certificateClaimCodes = new Array(CAP);
	const currentNetwork = (deployer.network === "dashboard") ? CHAIN_IDS[await web3.eth.getChainId()] : deployer.network;
	const silverMareCoinForwarder = await SilverMareCoinForwarder.deployed();
	await deployer.deploy(SilverMareCoinDCoA, CAP, SIGNERS[currentNetwork], silverMareCoinForwarder.address);
	const silverMareCoinDCoA = await SilverMareCoinDCoA.deployed();

	for (let i = 0; i < CAP; i++) {
		const number = i + 1;
		const certificateSigningHash = await silverMareCoinDCoA.certificateSigningHash(number);
		certificateClaimCodes[i] = { number, signature: await web3.eth.sign(certificateSigningHash, SIGNERS[currentNetwork]) };

		if (number < CAP && number % 10 === 0)
			await asyncDelay(1000);
	}
	await fs.writeFile(`claimCodes-${currentNetwork}.json`, JSON.stringify(certificateClaimCodes, null, "\t"));
}

module.exports = deploySilverMareCoinDCoA;