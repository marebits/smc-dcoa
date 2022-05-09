import { TokenGenericCollection } from "./TokenGenericCollection.mjs";
import { TokenMetadata } from "./TokenMetadata.mjs";

export class TokenMetadataCollection extends TokenGenericCollection {
	static #FILE_EXTENSION = "json";
	static #MIME_TYPE = "application/json";

	#svgUri;

	constructor(floor, cap, tokenMetadataDirectory, svgUri) {
		super(floor, cap, tokenMetadataDirectory, TokenMetadataCollection.#FILE_EXTENSION);
		this.#svgUri = svgUri;
		this.#populate();
	}
	get [globalThis.Symbol.toStringTag]() { return this.constructor.name; }
	get mimeType() { return this.constructor.#MIME_TYPE; }
	get svgUri() { return this.#svgUri; }
	get targetFileRegex() { return new globalThis.RegExp(`[0-9]+\\.${this.fileExtension}$`); }
	#populate() {
		for (let i = this.floor; i <= this.cap; i++)
			this.set(i, new TokenMetadata(i, this.cap, this.svgUri));
	}
}