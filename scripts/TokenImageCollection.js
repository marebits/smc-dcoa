const TokenGenericCollection = require("./TokenGenericCollection.js");
const TokenImage = require("./TokenImage.js");

module.exports = class TokenImageCollection extends TokenGenericCollection {
	static #FILE_EXTENSION = "svg";
	static #MIME_TYPE = "image/svg+xml";

	#cap;
	#floor;

	constructor(floor, cap, tokenImageDirectory) {
		super(floor, cap, tokenImageDirectory, TokenImageCollection.#FILE_EXTENSION);
		this.#populate();
	}
	get [globalThis.Symbol.toStringTag]() { return this.constructor.name; }
	get mimeType() { return this.constructor.#MIME_TYPE; }
	get targetFileRegex() { return new globalThis.RegExp(`[0-9]+\\.${this.fileExtension}$`); }
	#populate() {
		for (let i = this.floor; i <= this.cap; i++)
			this.set(i, new TokenImage(i, this.cap));
	}
}