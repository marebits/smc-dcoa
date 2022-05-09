import { TokenMetadata } from "./TokenMetadata.mjs";
import { prepareTemplate, processTemplate } from "./utils.js";

const CAP_SYMBOL = globalThis.Symbol("cap");
// wording
const NAME = "The Ride Never Ends";
const DESCRIPTION = prepareTemplate`The tokens issued by this contract guarantee that the original holder was a recipient of a coin from the initial minting of ${TokenMetadata.COIN_NAME} fine silver coins minted in ${TokenMetadata.TRAITS.Year} as part of the Silver Mare Coin project on /mlp/.  A total of ${CAP_SYMBOL} coins were minted and distributed.`;
const EXTERNAL_LINK = "https://4channel.org/mlp/";
const SELLER_FEE_BASIS_POINTS = 0;
const FEE_RECIPIENT = "0x0000000000000000000000000000000000000000";

export class ContractMetadata {
	#cap;
	#image;
	#symbol;

	constructor(cap, image, symbol) { [this.#cap, this.#image, this.#symbol] = [globalThis.Number.parseInt(cap), image, symbol]; }
	get [globalThis.Symbol.toStringTag]() { return this.constructor.name; }
	get #symbolDefinitions() { return { [CAP_SYMBOL]: this.#cap }; }
	get description() { return processTemplate(DESCRIPTION, this.#symbolDefinitions); }
	get external_link() { return EXTERNAL_LINK; }
	get fee_recipient() { return FEE_RECIPIENT; }
	get image() { return this.#image; }
	get name() { return NAME; }
	get seller_fee_basis_points() { return SELLER_FEE_BASIS_POINTS; }
	get symbol() { return this.#symbol; }
	[globalThis.Symbol.toPrimitive](hint) { return (hint === "number") ? this.valueOf() : this.toString(); }
	toJSON(key) {
		return {
			name: this.name, 
			description: this.description, 
			symbol: this.symbol, 
			image: this.image, 
			external_link: this.external_link, 
			seller_fee_basis_points: this.seller_fee_basis_points, 
			fee_recipient: this.fee_recipient
		};
	}
	toString() { return globalThis.JSON.stringify(this); }
	valueOf() { return this.#cap; }
}