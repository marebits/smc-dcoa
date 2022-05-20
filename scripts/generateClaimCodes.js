const fs = require("fs/promises");
const SIGNERS = require("./signers.js");
const utils = require("./utils.js");

const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");

async function generateClaimCodes(callbackFn) {
	try {
		const silverMareCoinDCoA = await SilverMareCoinDCoA.deployed();
		const [cap, currentNetwork] = await globalThis.Promise.all([silverMareCoinDCoA.cap(), utils.getNetworkName(undefined, globalThis.web3)]);
		const certificateClaimCodes = new Array(cap);
		const generatingMessage = "Generating claim code ";
		process.stdout.write(generatingMessage);

		for (let i = 0; i < cap; i++) {
			const number = i + 1;
			process.stdout.cursorTo(generatingMessage.length);
			process.stdout.write(`${number}/${cap}...`);
			const certificateSigningHash = await silverMareCoinDCoA.certificateSigningHash(number);
			certificateClaimCodes[i] = { number, signature: await globalThis.web3.eth.personal.sign(certificateSigningHash, SIGNERS[currentNetwork]) };

			if (number < cap && number % 10 === 0)
				await utils.asyncDelay(1000);
		}
		process.stdout.write("\n");
		console.log("Saving claim codes...")
		await fs.writeFile(`claimCodes-${currentNetwork}.json`, JSON.stringify(certificateClaimCodes, null, "\t"));
		console.log("Done!");
		callbackFn();
	} catch (e) {
		callbackFn(e);
	}
}

module.exports = generateClaimCodes;