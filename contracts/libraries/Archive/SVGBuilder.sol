// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./Base64Uri.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/*
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 700">
	<title>Digital Certificate of Authenticity for The Ride Never Ends fine silver coins minted in 2022.</title>
	<style>*{overflow:visible}text{cursor:default;dominant-baseline:middle;fill:#000;font-family:monospace;font-size:130%;text-anchor:middle;text-rendering:optimizeLegibility}.h1,.h2{font-weight:700}.h1{font-size:160%}.h2{font-size:150%}.italicized{font-style:italic}</style>
	<defs>
		<path id="edgeText" d="M112 420a238 238 1 0 1 476 1 238 238 1 0 1-476 1" />
	</defs>
	<rect width="100%" height="100%" fill="#f1c549" rx="3%" />
	<svg id="main" x="50%">
		<svg y="3%">
			<text class="h1">Digital Certificate of Authenticity (DCoA)</text>
			<text y="3%" class="h2">
				2022
				<tspan class="italicized">The Ride Never Ends</tspan>
			</text>
		</svg>
		<svg y="10%">
			<text>This DCoA certifies and guarantees that the original holder was a</text>
			<text y="3%">recipient of coin number 1 (out of 100) from the initial minting of</text>
			<text y="6%">
				<tspan class="italicized">The Ride Never Ends</tspan>
				fine silver coins minted in 2022 as part of
			</text>
			<text y="9%">the Silver Mare Coin project on /mlp/.</text>
		</svg>
	</svg>
	<circle cx="50%" cy="60%" r="38%" fill="#e1e1e1" stroke="#b5b5b5" stroke-width="1%" />
	<text y="50%">
		<textPath href="#edgeText" lengthAdjust="spacingAndGlyphs" spacing="auto" textLength="2990.8">MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎ MARES &#x1f340;︎</textPath>
	</text>
	<circle cx="50%" cy="60%" r="30%" fill="#e1e1e1" stroke="#b5b5b5" stroke-width="2%" />
	<text x="50%" y="60%" class="h1">PONY GOES HERE</text>
</svg>
*/

/**
 * @title Library grouping functions used to generate the SVG for individual tokens.
 * @author Twifag (solidity code)
 * @author anonymous (the SVG itself)
 */
library SVGBuilder {
	using Base64Uri for string;
	using Strings for uint256;

	string private constant MARES = unicode"MARES 🍀︎";
	uint8 private constant NUMBER_MARES = 36;

	/**
	 * @param number of the token
	 * @param cap maximum number of tokens
	 * @return The SVG image for the token
	 */
	function tokenSvg(uint16 number, uint16 cap) internal pure returns (string memory) {
		return string(abi.encodePacked(
			'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 700">'
				'<title>Digital Certificate of Authenticity for The Ride Never Ends fine silver coins minted in 2022.</title>'
				'<style>'
					'*{overflow:visible}'
					'text{cursor:default;dominant-baseline:middle;fill:#000;font-family:monospace;font-size:130%;text-anchor:middle;text-rendering:optimizeLegibility}'
					'.h1,.h2{font-weight:700}'
					'.h1{font-size:160%}'
					'.h2{font-size:150%}'
					'.italicized{font-style:italic}'
				'</style>'
				'<defs>'
					'<path id="edgeText" d="M112 420a238 238 1 0 1 476 1 238 238 1 0 1-476 1"/>'
				'</defs>'
				'<rect width="100%" height="100%" fill="#f1c549" rx="3%"/>'
				'<svg id="main" x="50%">'
					'<svg y="3%">'
						'<text class="h1">Digital Certificate of Authenticity (DCoA)</text>'
						'<text y="3%" class="h2">2022 <tspan class="italicized">The Ride Never Ends</tspan></text>'
					'</svg>'
					'<svg y="10%">'
						'<text>This DCoA certifies and guarantees that the original holder was a </text>'
						'<text y="3%">recipient of coin number ', uint256(number).toString(), ' (out of ', uint256(cap).toString(), ') from the initial minting of </text>'
						'<text y="6%"><tspan class="italicized">The Ride Never Ends</tspan> fine silver coins minted in 2022 as part of </text>'
						'<text y="9%">the Silver Mare Coin project on /mlp/.</text>'
					'</svg>'
				'</svg>', 
				'<circle cx="50%" cy="60%" r="38%" fill="#e1e1e1" stroke="#b5b5b5" stroke-width="1%"/>'
				'<text y="50%">'
					'<textPath href="#edgeText" lengthAdjust="spacingAndGlyphs" spacing="auto" textLength="2990.8">', 
						_generateMares(), 
					'</textPath>'
				'</text>'
				'<circle cx="50%" cy="60%" r="30%" fill="#e1e1e1" stroke="#b5b5b5" stroke-width="2%"/>'
				'<text x="50%" y="60%" class="h1">PONY GOES HERE</text>'
			'</svg>'
		));
	}

	/**
	 * @param number of the token
	 * @param cap maximum number of tokens
	 * @return The Base64-encoded data: URI for the SVG image for the token
	 */
	function tokenSvgUri(uint16 number, uint16 cap) internal pure returns (string memory) { return tokenSvg(number, cap).toBase64Uri("image/svg+xml"); }

	function _generateMares() private pure returns (bytes memory result) {
		result = abi.encodePacked(MARES);

		for (uint8 i = 1; i < NUMBER_MARES; i++) {
			result = abi.encodePacked(result, " ", MARES);
		}
	}
}