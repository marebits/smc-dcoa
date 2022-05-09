// Using this as a workaround, since Truffle migrations can't load ES6 modules correctly, even using dynamic imports...
class Files {
	static async loadModules() {
		const [{ ContractMetadataFile }, { TokenMetadataFiles }] = await globalThis.Promise.all([import("./ContractMetadataFile.mjs"), import("./TokenMetadataFiles.mjs")]);
		return { ContractMetadataFile, TokenMetadataFiles };
	}
}

module.exports = Files;