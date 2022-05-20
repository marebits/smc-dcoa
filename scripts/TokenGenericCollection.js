const FileGeneratorCollection = require("./FileGeneratorCollection.js");

module.exports = class TokenGenericCollection extends FileGeneratorCollection {
	#cap;
	#floor;

	constructor(floor, cap, directory, fileExtension) {
		super(directory, fileExtension);
		[this.#cap, this.#floor] = [globalThis.Number.parseInt(cap), globalThis.Number.parseInt(floor)];
	}
	get [globalThis.Symbol.toStringTag]() { return this.constructor.name; }
	get cap() { return this.#cap; }
	get floor() { return this.#floor; }
}