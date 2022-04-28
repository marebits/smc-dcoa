export class MultiLineSentence {
	static DEFAULT_LINE_LENGTH = 100;
	#lineLength;
	#sentence;
	#sentenceArray;

	constructor(sentence, lineLength) { [this.lineLength, this.sentence] = [lineLength, sentence]; }
	get [globalThis.Symbol.toStringTag]() { return "MultiLineSentence"; }
	get length() { return this.sentenceArray.length; }
	get lineLength() { return this.#lineLength; }
	get sentence() { return this.#sentence; }
	get sentenceArray() {
		if (globalThis.Array.isArray(this.#sentenceArray))
			return this.#sentenceArray;
		let i = 0;
		this.#sentenceArray = [""];
		this.sentence.split(" ").forEach(word => {
			const proposedLine = `${this.#sentenceArray[i]} ${word}`.trim();
			const proposedLineLength = proposedLine.replace(/<[^>]+>/g, "").length;

			if (proposedLineLength <= this.lineLength)
				this.#sentenceArray[i] = proposedLine;
			else if (this.#sentenceArray[i].length === 0)
				this.#sentenceArray[i++] = proposedLine;
			else
				this.#sentenceArray[++i] = word;
		});
		return this.#sentenceArray;
	}
	set lineLength(lineLength) {
		lineLength = globalThis.Number.parseInt(lineLength);
		[this.#lineLength, this.#sentenceArray] = [(!globalThis.Number.isInteger(lineLength) || lineLength <= 0) ? this.constructor.DEFAULT_LINE_LENGTH : lineLength, undefined];
	}
	set sentence(sentence) { [this.#sentence, this.#sentenceArray] = [globalThis.String(sentence), undefined]; }
	*[globalThis.Symbol.iterator]() {
		for (const word of this.sentenceArray)
			yield word;
	}
	[globalThis.Symbol.toPrimitive](hint) { return (hint === "number") ? this.valueOf() : this.toString(); }
	forEach(...args) { return this.sentenceArray.forEach(...args); }
	map(...args) { return this.sentenceArray.map(...args); }
	reduce(...args) { return this.sentenceArray.reduce(...args); }
	toArray() { return this.sentenceArray; }
	toJSON() { return this.sentenceArray; }
	toString() { return this.sentenceArray.join("\n"); }
	valueOf() { return this.length; }
}