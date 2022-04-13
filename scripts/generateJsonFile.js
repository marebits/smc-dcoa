const fs = require("fs/promises");
const generateSvgFile = require("./generateSvgFile.js");
const path = require("path");

async function generateJsonFile(tokenMetadataPath, number, cap) {
	[number, cap] = [globalThis.Number.parseInt(number), globalThis.Number.parseInt(cap)];
	// key data
	const BACKGROUND_COLOR = "cc9cdf";
	const COIN_NAME = "*The Ride Never Ends*";
	const JSON_METADATA_PATH = "json";
	const TRAITS = {
		Composition: "Silver (.999)", 
		Diameter: "39 mm", 
		Location: "United States", 
		Mass: "1 troy oz", 
		"Numista Type Number": "TBD", 
		Orientation: "Coin alignment ↑↓", 
		"Serial Number": {
			display_type: "number", 
			max_value: cap, 
			value: number
		}, 
		Shape: "Round", 
		Technique: "Milled", 
		Thickness: "0.12 in", 
		Year: "2022"
	};
	// wording
	const NAME = `Silver Mare Coin Digital Certificate of Authenticity #${number}/${cap}`;
	const HEADING = "Digital Certificate of Authenticity (DCoA)";
	const TITLE = `${TRAITS.Year} ${COIN_NAME}`;
	const SUBTITLE = "One Ounce Fine Silver";
	const DESCRIPTION = `This DCoA certifies and guarantees that the original holder was a recipient of coin number ${number} (out of ${cap}) from the initial minting of ${COIN_NAME} fine silver coins minted in ${TRAITS.Year} as part of the Silver Mare Coin project on /mlp/.`;
	const OBVERSE_DESCRIPTION = "Anonfilly riding a roller coaster while wearing a /mlp/ 4cc scarf with Canterlot in the background.";
	const OBVERSE_LETTERING = "THE RIDE NEVER ENDS \n2012 2022";
	const REVERSE_DESCRIPTION = "An earth, pegasus, and unicorn pony decorating the /mlp/ seal with laurels.";
	const REVERSE_LETTERING = "MARES 🍀︎ repeated along the rim \n1 OZ FINE SILVER along bottom of rim";
	const EDGE_DESCRIPTION = "Engraved with repeating Latin motto.";
	const EDGE_LETTERING = "EQUITATUS NUMQUAM FINIT";

	function generateDescription() {
		const formatLettering = lettering => `*Lettering*: ${lettering.includes("\n") ? "\n" : ""}${lettering}`;

		return `# ${HEADING} 
## ${TITLE} 
## ${SUBTITLE} 
${DESCRIPTION} 

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

	function generateTraits() {
		return globalThis.Object.entries(TRAITS).map(([trait_type, value]) => (typeof value === "object" && "value" in value) ? globalThis.Object.assign({ trait_type }, value) : { trait_type, value });
	}

	const metadata = {
		name: NAME, 
		description: generateDescription(), 
		image: await generateSvgFile(tokenMetadataPath, number, cap), 
		background_color: BACKGROUND_COLOR, 
		attributes: generateTraits()
	};
	await fs.writeFile(path.join(tokenMetadataPath, JSON_METADATA_PATH, `${number}.json`), globalThis.JSON.stringify(metadata));
}

module.exports = generateJsonFile;