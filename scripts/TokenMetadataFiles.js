const SECRETS = require("../secrets.json");
const TokenImageCollection = require("./TokenImageCollection.js");
const TokenMetadataCollection = require("./TokenMetadataCollection.js");
const { File, NFTStorage } = require("nft.storage");
const Path = require("path");
const Process = require("process");

module.exports = class TokenMetadataFiles {
	static #DIRECTORY = "./token-metadata";
	static #METADATA_SUBDIR = "json";
	static #SVG_SUBDIR = "svg";

	#_nftClient;
	#cap;
	#floor;
	#metadata;
	#metadataUri;
	#directory;
	#svg;
	#svgUri;

	constructor(floor, cap) {
		[this.#cap, this.#floor] = [globalThis.Number.parseInt(cap), globalThis.Number.parseInt(floor)];
		this.#directory = Path.isAbsolute(this.constructor.#DIRECTORY) ? this.constructor.#DIRECTORY : Path.normalize(Path.join(Process.cwd(), this.constructor.#DIRECTORY));
	}
	get [globalThis.Symbol.toStringTag]() { return this.constructor.name; }
	get #nftClient() { return (this.#_nftClient instanceof NFTStorage) ? this.#_nftClient : this.#_nftClient = new NFTStorage({ token: SECRETS.NFT_STORAGE_API_KEY }); }
	get cap() { return this.#cap; }
	get directory() { return this.#directory; }
	get floor() { return this.#floor; }
	get metadata() {
		if (!(this.#metadata instanceof globalThis.Promise))
			this.#metadata = (async () => {
				await this.#uploadAllSvg();
				return new TokenMetadataCollection(this.floor, this.cap, Path.join(this.directory, this.constructor.#METADATA_SUBDIR), this.svgUri);
			})().catch(console.error);
		return this.#metadata;
	}
	get metadataUri() { return this.#metadataUri; }
	get svg() {
		if (!(this.#svg instanceof TokenImageCollection))
			this.#svg = new TokenImageCollection(this.floor, this.cap, Path.join(this.directory, this.constructor.#SVG_SUBDIR));
		return this.#svg;
	}
	get svgUri() { return this.#svgUri; }
	#displayMessage(domain, message) { console.log(`${domain}: ${message}`); }
	async #uploadAllGeneric(tokenGenericCollection) {
		this.#displayMessage(tokenGenericCollection.constructor.name, "Generating CAR file...");
		const { cid, car } = await NFTStorage.encodeDirectory(tokenGenericCollection.reduce((files, current) => {
			files.push(new File([current.value.toString()], `${current.key}.${tokenGenericCollection.fileExtension}`, { type: tokenGenericCollection.mimeType }));
			return files;
		}, new globalThis.Array()));
		this.#displayMessage(tokenGenericCollection.constructor.name, "Uploading CAR file...");
		await this.#nftClient.storeCar(car);
		this.#displayMessage(tokenGenericCollection.constructor.name, "Upload complete.");
		return `ipfs://${cid}/`;
	}
	async #uploadAllMetadata() { this.#metadataUri = await this.#uploadAllGeneric(await this.metadata); }
	async #uploadAllSvg() { this.#svgUri = await this.#uploadAllGeneric(this.svg); }
	async uploadAll() { await this.#uploadAllMetadata(); }
}