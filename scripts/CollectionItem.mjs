export class CollectionItem {
	#key;
	#value;

	constructor(item) { [this.#key, this.#value] = item; }
	get [globalThis.Symbol.toStringTag]() { return "CollectionItem"; }
	get key() { return this.#key; }
	get value() { return this.#value; }
	*[globalThis.Symbol.iterator]() {
		yield this.key;
		yield this.value;
	}
	[globalThis.Symbol.toPrimitive](hint) { return (hint === "number") ? this.valueOf() : this.toString(); }
	toArray() { return [this.key, this.value]; }
	toJSON() { return { [this.key]: this.value } };
	toString() { return `${this.key}: ${this.value}`; }
	valueOf() { return 2; }
}