import SECRETS from "../secrets.json" assert { type: "json" };
import { ContractMetadata } from "./ContractMetadata.mjs";
import * as FileSystem from "fs/promises";
import { File, NFTStorage } from "nft.storage";
import * as Path from "path";
import * as Process from "process";
import { URL } from "url";

const IMAGE_FILE = "./dcoa.svg";
const FILE_NAME_PREFIX = "SilverMareCoinDCoA";
const IMAGE = globalThis.Object.freeze({ DOMAIN: "Image", FILE_EXTENSION: "svg", MIME_TYPE: "image/svg+xml" });
const METADATA = globalThis.Object.freeze({ DOMAIN: "Metadata", FILE_EXTENSION: "json", MIME_TYPE: "application/json" });

export class ContractMetadataFile {
	#_nftClient;
	#cap;
	#image;
	#imageUri;
	#metadata;
	#metadataUri;
	#symbol;

	constructor(cap, symbol) { [this.#cap, this.#symbol] = [globalThis.Number.parseInt(cap), symbol]; }
	get [globalThis.Symbol.toStringTag]() { return this.constructor.name; }
	get #nftClient() { return (this.#_nftClient instanceof NFTStorage) ? this.#_nftClient : this.#_nftClient = new NFTStorage({ token: SECRETS.NFT_STORAGE_API_KEY }); }
	get image() {
		// TBD
		// can build SVG in a ContractImage, read external file from filesystem, whatever...
		if (!(this.#image instanceof globalThis.Promise))
			this.#image = FileSystem.readFile(Path.normalize(Path.join(Process.cwd(), IMAGE_FILE)), { encoding: "utf8" }).catch(console.error);
		return this.#image;
	}
	get imageUri() { return this.#imageUri; }
	get metadata() {
		if (!(this.#metadata instanceof globalThis.Promise))
			this.#metadata = (async () => {
				await this.#uploadImage();
				return new ContractMetadata(this.cap, this.imageUri, this.symbol);
			})().catch(console.error);
		return this.#metadata;
	}
	get metadataUri() { return this.#metadataUri; }
	get symbol() { return this.#symbol; }
	#displayMessage(domain, message) { console.log(`Contract Metadata ${domain}: ${message}`); }
	async #uploadGeneric(data, descriptor) {
		const fileName = `${FILE_NAME_PREFIX}.${descriptor.FILE_EXTENSION}`;
		this.#displayMessage(descriptor.DOMAIN, "Generating CAR file...");
		const { cid, car } = await NFTStorage.encodeDirectory([new File([data.toString()], fileName, { type: descriptor.MIME_TYPE })]);
		this.#displayMessage(descriptor.DOMAIN, "Uploading CAR file...");
		await this.#nftClient.storeCar(car);
		this.#displayMessage(descriptor.DOMAIN, "Upload complete.");
		return (new URL(fileName, `ipfs://${cid}/`)).toString();
	}
	async #uploadImage() { this.#imageUri = await this.#uploadGeneric(await this.image, IMAGE); }
	async #uploadMetadata() { this.#metadataUri = await this.#uploadGeneric(await this.metadata, METADATA); }
	async upload() { await this.#uploadMetadata(); }
}