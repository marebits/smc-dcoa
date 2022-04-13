const fs = require("fs/promises");
const generateJsonFile = require("./generateJsonFile.js");
const util = require("util");

const SilverMareCoinDCoA = artifacts.require("SilverMareCoinDCoA");

const TOKEN_METADATA_PATH = "token-metadata";

async function generateJsonFiles(callbackFn) {
	try {
		const silverMareCoinDCoA = await SilverMareCoinDCoA.deployed();
		const cap = await silverMareCoinDCoA.cap();
		const floor = await silverMareCoinDCoA.floor();
		const files = new globalThis.Array();

		for (let i = floor; i <= cap; i++) {
			files.push(generateJsonFile(TOKEN_METADATA_PATH, i, cap));
		}
		await globalThis.Promise.all(files);
		callbackFn();
	} catch (e) { callbackFn(e); }
}

module.exports = generateJsonFiles;