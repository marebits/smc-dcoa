const fs = require("fs/promises");
const SIGNERS = require("./signers.js");
const utils = require("./utils.js");

const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");

function asyncDelay(delayTimeMs) { return new Promise(resolve => setTimeout(resolve, delayTimeMs)); }

async function generateClaimCodes(callbackFn) {
	const currentNetwork = await utils.getNetworkName(config);
	const silverMareCoinDCoA = await SilverMareCoinDCoA.deployed();
	const cap = await silverMareCoinDCoA.cap();
	const certificateClaimCodes = new Array(cap);

	for (let i = 0; i < cap; i++) {
		const number = i + 1;
		const certificateSigningHash = await silverMareCoinDCoA.certificateSigningHash(number);
		certificateClaimCodes[i] = { number, signature: await web3.eth.sign(certificateSigningHash, SIGNERS[currentNetwork]) };

		if (number < cap && number % 10 === 0)
			await asyncDelay(1000);
	}
	await fs.writeFile(`claimCodes-${currentNetwork}.json`, JSON.stringify(certificateClaimCodes, null, "\t"));
	callbackFn();
}

module.exports = generateClaimCodes;