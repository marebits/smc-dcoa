import SECRETS from "../secrets.json" assert { type: "json" };
import { TokenImageCollection } from "./TokenImageCollection.mjs";
import { TokenMetadataCollection } from "./TokenMetadataCollection.mjs";
import { constants as FILE_SYSTEM_CONSTANTS } from "fs";
import * as FileSystem from "fs/promises";
import { FsBlockStore } from "ipfs-car/blockstore/fs";
import { packToFs } from "ipfs-car/pack/fs";
import * as Path from "path";
import * as Process from "process";

export class TokenMetadataFiles {
	static #DIRECTORY = "./token-metadata";
	static #METADATA_CAR_FILE = "json.car";
	static #METADATA_SUBDIR = "json";
	static #SVG_CAR_FILE = "svg.car";
	static #SVG_SUBDIR = "svg";

	#cap;
	#floor;
	#metadata;
	#directory;
	#svg;
	metadataUri;
	svgUri;

	constructor(floor, cap) {
		[this.#cap, this.#floor] = [globalThis.Number.parseInt(cap), globalThis.Number.parseInt(floor)];
		this.#directory = Path.isAbsolute(this.constructor.#DIRECTORY) ? this.constructor.#DIRECTORY : Path.normalize(Path.join(Process.cwd(), this.constructor.#DIRECTORY));
	}
	get [globalThis.Symbol.toStringTag]() { return "TokenMetadataFiles"; }
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
	get metadataCarFilePath() { return Path.join(this.directory, this.constructor.#METADATA_CAR_FILE); }
	get svg() {
		if (!(this.#svg instanceof TokenImageCollection))
			this.#svg = new TokenImageCollection(this.floor, this.cap, Path.join(this.directory, this.constructor.#SVG_SUBDIR));
		return this.#svg;
	}
	get svgCarFilePath() { return Path.join(this.directory, this.constructor.#SVG_CAR_FILE); }
	async #uploadAllGeneric(carFilePath, directory, saveAllFn) {
		await FileSystem.access(this.directory, FILE_SYSTEM_CONSTANTS.W_OK);
		await globalThis.Promise.all([FileSystem.rm(carFilePath, { force: true }), saveAllFn()]);
		const { root } = await packToFs({ blockstore: new FsBlockStore(), input: directory, output: carFilePath });
		return `ipfs://${root}`;
	}
	async #uploadAllMetadata() {
		const metadata = await this.metadata;
		this.metadataUri = await this.#uploadAllGeneric(this.metadataCarFilePath, metadata.directory, metadata.saveAll.bind(metadata));
	}
	async #uploadAllSvg() { this.svgUri = await this.#uploadAllGeneric(this.svgCarFilePath, this.svg.directory, this.svg.saveAll.bind(this.svg)); }
	async uploadAll() { await this.#uploadAllMetadata(); }
}