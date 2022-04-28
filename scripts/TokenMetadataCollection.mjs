import { FileGeneratorCollection } from "./FileGeneratorCollection.mjs";
import { TokenMetadata } from "./TokenMetadata.mjs";

export class TokenMetadataCollection extends FileGeneratorCollection {
	static #FILE_EXTENSION = "json";

	#cap;
	#floor;
	#svgUri;

	constructor(floor, cap, tokenMetadataDirectory, svgUri) {
		super(tokenMetadataDirectory, TokenMetadataCollection.#FILE_EXTENSION);
		[this.#cap, this.#floor, this.#svgUri] = [globalThis.Number.parseInt(cap), globalThis.Number.parseInt(floor), svgUri];
		this.#populate();
	}
	get [globalThis.Symbol.toStringTag]() { return "TokenMetadataCollection"; }
	get cap() { return this.#cap; }
	get floor() { return this.#floor; }
	get svgUri() { return this.#svgUri; }
	get targetFileRegex() { return new globalThis.RegExp(`[0-9]+\\.${this.fileExtension}$`); }
	#populate() {
		for (let i = this.floor; i <= this.cap; i++)
			this.set(i, new TokenMetadata(i, this.cap, this.svgUri));
	}
}