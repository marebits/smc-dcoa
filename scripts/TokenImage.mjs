import { MultiLineSentence } from "./MultiLineSentence.mjs";
import { prepareTemplate, processTemplate } from "./utils.js";

const CAP_SYMBOL = globalThis.Symbol("cap");
const NUMBER_SYMBOL = globalThis.Symbol("number");
const BACKGROUND_COLOR = "#f1c549";
const FOREGROUND_COLOR = "#000";
const COIN_NAME = "The Ride Never Ends";
const DESCRIPTION_DETAIL_OFFSET = "10%";
const DESCRIPTION_HEADER_OFFSET = "3%";
const DESCRIPTION_LINE_HEIGHT_PERCENTAGE = 3;
const DESCRIPTION_WIDTH = 65;
const MINTED_YEAR = "2022";

const COIN_NAME_SYMBOL = globalThis.Symbol(COIN_NAME);
const FULL_TITLE = `Digital Certificate of Authenticity for ${COIN_NAME} fine silver coins minted in ${MINTED_YEAR}.`;
const DESCRIPTION_TITLE = "Digital Certificate of Authenticity (DCoA)";
const DESCRIPTION_SUBTITLE = prepareTemplate`${MINTED_YEAR} ${COIN_NAME_SYMBOL}`;
const DESCRIPTION = prepareTemplate`This DCoA certifies and guarantees that the original holder was a recipient of coin number ${NUMBER_SYMBOL} (out of ${CAP_SYMBOL}) from the initial minting of ${COIN_NAME_SYMBOL} fine silver coins minted in ${MINTED_YEAR} as part of the Silver Mare Coin project on /mlp/.`;
const STYLE = `*{overflow:visible}text{cursor:default;dominant-baseline:middle;fill:${FOREGROUND_COLOR};font-family:monospace;font-size:130%;text-anchor:middle;text-rendering:optimizeLegibility}.h1,.h2{font-weight:700}.h1{font-size:160%}.h2{font-size:150%}.italicized{font-style:italic}`;

const IMAGE = `<defs><path id="edgeText" d="M112 420a238 238 1 0 1 476 1 238 238 1 0 1-476 1" /></defs><circle cx="50%" cy="60%" r="38%" fill="#e1e1e1" stroke="#b5b5b5" stroke-width="1%" /><text y="50%"><textPath href="#edgeText" lengthAdjust="spacingAndGlyphs" spacing="auto" textLength="2990.8">MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎</textPath></text><circle cx="50%" cy="60%" r="30%" fill="#e1e1e1" stroke="#b5b5b5" stroke-width="2%" /><text x="50%" y="60%" class="h1">PONY GOES HERE</text>`;

export class TokenImage {
	#cap;
	#number;

	constructor(number, cap) { [this.#cap, this.#number] = [globalThis.Number.parseInt(cap), globalThis.Number.parseInt(number)]; }
	get #symbolDefinitions() { return { [CAP_SYMBOL]: this.#cap, [COIN_NAME_SYMBOL]: this.createElement("i", COIN_NAME), [NUMBER_SYMBOL]: this.number }; }
	get [globalThis.Symbol.toStringTag]() { return this.constructor.name; }
	get background() { return this.createElement("rect", "", { width: "100%", height: "100%", fill: BACKGROUND_COLOR, rx: "3%" }); }
	get description() {
		const descriptionTitle = this.createElement("h1", DESCRIPTION_TITLE);
		const descriptionSubtitle = this.createElement("h2", processTemplate(DESCRIPTION_SUBTITLE, this.#symbolDefinitions), { y: `${DESCRIPTION_LINE_HEIGHT_PERCENTAGE}%` });
		const descriptionHeader = this.createElement("svg", `${descriptionTitle}${descriptionSubtitle}`, { y: DESCRIPTION_HEADER_OFFSET });
		const descriptionSentence = new MultiLineSentence(processTemplate(DESCRIPTION, this.#symbolDefinitions), DESCRIPTION_WIDTH);
		const descriptionText = descriptionSentence.sentenceArray.map((line, i) => this.createElement("text", line, (i === 0) ? {} : { y: `${DESCRIPTION_LINE_HEIGHT_PERCENTAGE * i}%` })).join("");
		const descriptionDetail = this.createElement("svg", descriptionText, { y: DESCRIPTION_DETAIL_OFFSET });
		return this.createElement("svg", `${descriptionHeader}${descriptionDetail}`, { id: "main", x: "50%" });
	}
	get document() {
		const doc = this.createElement("svg", `${this.title}${this.style}${this.background}${this.description}${this.image}`, { xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 700 700" });
		return `<?xml version="1.0" encoding="UTF-8"?>${doc}`;
	}
	get image() { return IMAGE; }
	get number() { return this.#number; }
	get style() { return this.createElement("style", STYLE); }
	get title() { return this.createElement("title", FULL_TITLE); }
	[globalThis.Symbol.toPrimitive](hint) { return (hint === "number") ? this.valueOf() : this.toString(); }
	createElement(name, contents = "", attributes = {}) {
		if (name === "h1" || name === "h2")
			return this.createElement("text", contents, globalThis.Object.assign({}, attributes, { class: name }));
		else if (name === "i")
			return this.createElement("tspan", contents, globalThis.Object.assign({}, attributes, { class: "italicized" }));
		const attributesEntries = globalThis.Object.entries(attributes);
		const attributesString = (attributesEntries.length > 0) ? ` ${attributesEntries.map(([key, value]) => `${key}="${value}"`).join(" ")}` : "";
		return (contents.length > 0) ? `<${name}${attributesString}>${contents}</${name}>` : `<${name}${attributesString} />`;
	}
	toString() { return this.document; }
	valueOf() { return this.number; }
}