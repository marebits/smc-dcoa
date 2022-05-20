const { prepareTemplate, processTemplate } = require("./utils.js");

const CAP_SYMBOL = globalThis.Symbol("cap");
const NUMBER_SYMBOL = globalThis.Symbol("number");
// key data
const BACKGROUND_COLOR = "cc9cdf";
const COIN_NAME = "*The Ride Never Ends*";
const TRAITS = globalThis.Object.freeze({
	Composition: "Silver (.999)", 
	Diameter: "39 mm", 
	Location: "United States", 
	Weight: "31.10 g", 
	"Numista Type Number": "TBD", 
	Orientation: "Coin alignment ↑↓", 
	"Serial Number": {
		display_type: "number", 
		max_value: CAP_SYMBOL, 
		value: NUMBER_SYMBOL
	}, 
	Shape: "Round", 
	Technique: "Milled", 
	Thickness: "3.05 mm", 
	Year: "2022"
});
// wording
const NAME = prepareTemplate`Silver Mare Coin Digital Certificate of Authenticity #${NUMBER_SYMBOL}/${CAP_SYMBOL}`;
const HEADING = "Digital Certificate of Authenticity (DCoA)";
const TITLE = `${TRAITS.Year} ${COIN_NAME}`;
const SUBTITLE = "One Ounce Fine Silver";
const DESCRIPTION = prepareTemplate`This DCoA certifies and guarantees that the original holder was a recipient of coin number ${NUMBER_SYMBOL} (out of ${CAP_SYMBOL}) from the initial minting of ${COIN_NAME} fine silver coins minted in ${TRAITS.Year} as part of the Silver Mare Coin project on /mlp/.`;
const OBVERSE_DESCRIPTION = "Anonfilly, facing left, riding roller coaster while wearing /mlp/ 4cc scarf with Canterlot in background.";
const OBVERSE_LETTERING = "THE RIDE NEVER ENDS \n2012 ¡ 2022";
const REVERSE_DESCRIPTION = "Earth, pegasus, and unicorn pony decorating /mlp/ seal with laurels.";
const REVERSE_LETTERING = "MARES 🍀︎ \nEQUIFUTUTORES \n1 OZ FINE SILVER";
const EDGE_DESCRIPTION = "Engraved with repeating Latin motto separated by 🍀︎.";
const EDGE_LETTERING = "EQUITATUS 🍀︎ NUMQUAM 🍀︎ FINIT 🍀︎";

module.exports = class TokenMetadata {
	static get COIN_NAME() { return COIN_NAME; }
	static get TRAITS() { return TRAITS; }

	#cap;
	#number;
	#svgUri;

	constructor(number, cap, svgUri) { [this.#cap, this.#number, this.#svgUri] = [globalThis.Number.parseInt(cap), globalThis.Number.parseInt(number), svgUri]; }

	get #name() { return processTemplate(NAME, this.#symbolDefinitions); }
	get #description() { return processTemplate(DESCRIPTION, this.#symbolDefinitions); }
	get #symbolDefinitions() { return { [CAP_SYMBOL]: this.#cap, [NUMBER_SYMBOL]: this.#number }; }
	get [globalThis.Symbol.toStringTag]() { return this.constructor.name; }
	get attributes() {
		return globalThis.Object.entries(TRAITS).map(([trait_type, value]) => {
			if (typeof value === "object" && "value" in value) {
				const result = globalThis.Object.assign({ trait_type }, value);
				globalThis.Object.entries(result).forEach(([key, value]) => {
					if (typeof value === "symbol")
						result[key] = this.#symbolDefinitions[value];
				});
				return result;
			}
			else if (typeof value === "symbol")
				return { trait_type, value: this.#symbolDefinitions[value] };
			return { trait_type, value };
		});
	}
	get background_color() { return BACKGROUND_COLOR; }
	get description() {
		const formatLettering = lettering => `*Lettering*: ${lettering.includes("\n") ? "\n" : ""}${lettering}`;
		// heredoc
		return `# ${HEADING} 
## ${TITLE} 
## ${SUBTITLE} 
${this.#description} 

### Obverse 
${OBVERSE_DESCRIPTION}
${formatLettering(OBVERSE_LETTERING)}

### Reverse
${REVERSE_DESCRIPTION}
${formatLettering(REVERSE_LETTERING)}

### Edge
${EDGE_DESCRIPTION}
${formatLettering(EDGE_LETTERING)}`;
	}
	get image() { return new globalThis.URL(`${this.#number}.svg`, this.#svgUri); }
	get name() { return this.#name; }
	[globalThis.Symbol.toPrimitive](hint) { return (hint === "number") ? this.valueOf() : this.toString(); }
	toJSON(key) { return { name: this.name, description: this.description, image: this.image, background_color: this.background_color, attributes: this.attributes }; }
	toString() { return globalThis.JSON.stringify(this); }
	valueOf() { return this.#number; }
}