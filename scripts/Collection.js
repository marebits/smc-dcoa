const CollectionItem = require("./CollectionItem.js");

const COLLECTIONS = new globalThis.WeakMap();

class Collection {
	constructor() { COLLECTIONS.set(this, new globalThis.Map()); }
	get [globalThis.Symbol.toStringTag]() { return "Collection"; }
	get #collection() { return COLLECTIONS.get(this); }
	get entries() { return this[globalThis.Symbol.iterator]; }
	get size() { return this.#collection.size; }
	*[globalThis.Symbol.iterator]() {
		for (const item of this.#collection)
			yield new CollectionItem(item);
	}
	[globalThis.Symbol.toPrimitive](hint) { return (hint === "number") ? this.valueOf() : this.toString(); }
	clear() { this.#collection.clear(); }
	delete(key) { return this.#collection.delete(key); }
	forEach(callbackFn) {
		for (const item of this)
			callbackFn.call(undefined, item, this);
	}
	get(key) { return this.#collection.get(key); }
	has(key) { return this.#collection.has(key); }
	join(separator = undefined) {
		if (typeof separator === "undefined")
			separator = ",";
		let result = "";

		for (const item of this)
			result = `${result}${separator}${item.value}`;
		return result.substring(separator.length);
	}
	keys() { return this.#collection.keys(); }
	map(callbackFn) {
		const result = new this.constructor();

		for (const item of this) {
			const newItem = callbackFn.call(undefined, item, this);
			result.set(...newItem);
		}
		return result;
	}
	reduce(callbackFn, initialValue = undefined) {
		let isFirstIteration = true;
		let previousValue = initialValue;

		for (const item of this) {
			if (isFirstIteration) {
				isFirstIteration = false;

				if (typeof initialValue === "undefined") {
					previousValue = item;
					continue;
				}
			}
			previousValue = callbackFn.call(undefined, previousValue, item, this);
		}
		return previousValue;
	}
	set(key, value) {
		this.#collection.set(key, value);
		return this;
	}
	toArray() {
		const result = new globalThis.Array();

		for (const item of this)
			result.push([...item]);
		return result;
	}
	toJSON() {
		const result = new globalThis.Array();

		for (const item of this)
			result.push(item.toJSON());
		return result;
	}
	toString() { return this.join(); }
	valueOf() { return this.size; }
	values() { return this.#collection.values(); }
}

class PromiseCollection extends Collection {
	get #collection() { return COLLECTIONS.get(this); }
	get entries() { return this[globalThis.Symbol.asyncIterator]; }
	async *[globalThis.Symbol.asyncIterator]() {
		for (const [key, value] of this.#collection)
			yield new CollectionItem([key, await value]);
	}
	async forEach(callbackFn) {
		for await (const item of this)
			callbackFn.call(undefined, item, this);
	}
	async join(separator = undefined) {
		if (typeof separator === "undefined")
			separator = ",";
		let result = "";

		for await (const item of this)
			result = `${result}${separator}${item.value}`;
		return result.substring(separator.length);
	}
	async map(callbackFn) {
		const result = new this.constructor();

		for await (const item of this) {
			const newItem = callbackFn.call(undefined, item, this);
			result.set(...newItem);
		}
		return result;
	}
	async reduce(callbackFn, initialValue = undefined) {
		let isFirstIteration = true;
		let previousValue = initialValue;

		for await (const item of this) {
			if (isFirstIteration) {
				isFirstIteration = false;

				if (typeof initialValue === "undefined") {
					previousValue = item;
					continue;
				}
			}
			previousValue = callbackFn.call(undefined, previousValue, item, this);
		}
		return previousValue;
	}
	async toArray() {
		const result = new globalThis.Array();

		for await (const item of this)
			result.push([...item]);
		return result;
	}
	async toJSON() {
		const result = new globalThis.Array();

		for await (const item of this)
			result.push(item.toJSON());
		return result;
	}
}

module.exports = { Collection, PromiseCollection };