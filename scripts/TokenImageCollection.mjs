import { FileGeneratorCollection } from "./FileGeneratorCollection.mjs";
import { TokenImage } from "./TokenImage.mjs";

export class TokenImageCollection extends FileGeneratorCollection {
	static #FILE_EXTENSION = "svg";

	#cap;
	#floor;

	constructor(floor, cap, tokenImageDirectory) {
		super(tokenImageDirectory, TokenImageCollection.#FILE_EXTENSION);
		[this.#cap, this.#floor] = [globalThis.Number.parseInt(cap), globalThis.Number.parseInt(floor)];
		this.#populate();
	}
	get [globalThis.Symbol.toStringTag]() { return "TokenImageCollection"; }
	get cap() { return this.#cap; }
	get floor() { return this.#floor; }
	get targetFileRegex() { return new globalThis.RegExp(`[0-9]+\\.${this.fileExtension}$`); }
	#populate() {
		for (let i = this.floor; i <= this.cap; i++)
			this.set(i, new TokenImage(i, this.cap));
	}
}