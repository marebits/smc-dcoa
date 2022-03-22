// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./Base64Uri.sol";
import "./MetadataBuilder.sol";
import { UFixed24x2, UFixed24x2Math } from "./UFixed24x2.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Library grouping functions used to generate the SVG for individual tokens.
 * @author Twifag (solidity code)
 * @author anonymous (the SVG itself)
 */
library SVGBuilder {
	using Base64Uri for string;
	using Strings for uint256;

	bytes internal constant CLOVER = abi.encodePacked(unicode'🍀︎');
	uint24 internal constant COIN_DELTA_R_PCT = 4;
	string internal constant COIN_FILL = "#e1e1e1";
	string internal constant COIN_INNER_STROKE_WIDTH_PCT = "2";
	string internal constant COIN_NAME = "The Ride Never Ends";
	uint24 internal constant COIN_OUTER_R_PCT = 38;
	string internal constant COIN_OUTER_STROKE_WIDTH_PCT = "1";
	bytes internal constant COIN_RIM_TEXT = abi.encodePacked(CLOVER, " MARES ");
	uint8 internal constant COIN_RIM_TEXT_COUNT = 35;
	string internal constant COIN_STROKE = "#b5b5b5";
	UFixed24x2 internal constant COIN_X_PCT = UFixed24x2.wrap(50);
	UFixed24x2 internal constant COIN_Y_PCT = UFixed24x2.wrap(60);
	UFixed24x2 internal constant PI = UFixed24x2.wrap(314);
	uint24 internal constant VIEW_BOX_SIZE = 700;

	uint24 internal constant COIN_INNER_R_PCT = COIN_OUTER_R_PCT - 2 * COIN_DELTA_R_PCT;
	UFixed24x2 internal constant COIN_RIM_TEXT_R_PCT = UFixed24x2.wrap(COIN_OUTER_R_PCT - COIN_DELTA_R_PCT);

	/**
	 * @param params describing the token
	 * @return The SVG image for the token
	 */
	function tokenSvg(MetadataBuilder.TokenParams memory params) internal pure returns (string memory) {
		string memory viewBoxSize = uint256(VIEW_BOX_SIZE).toString();
		return string(abi.encodePacked(
			'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ', viewBoxSize, ' ', viewBoxSize, '">'
				'<title>Digital Certificate of Authenticity for ', COIN_NAME, ' fine silver coins minted in 2022.</title>'
				'<style>'
					'*{overflow:visible}'
					'text{cursor:default;dominant-baseline:middle;fill:#000;font-family:monospace;font-size:130%;text-anchor:middle;text-rendering:optimizeLegibility}'
					'.h1,.h2{font-weight:700}'
					'.h1{font-size:160%}'
					'.h2{font-size:150%}'
					'.italicized{font-style:italic}'
				'</style>'
				'<defs>', 
					_generateCoinRimTextPath(), 
				'</defs>'
				'<rect width="100%" height="100%" fill="#f1c549" rx="3%"/>'
				'<svg id="main" x="50%">'
					'<svg y="3%">'
						'<text class="h1">Digital Certificate of Authenticity (DCoA)</text>'
						'<text y="3%" class="h2">2022 <tspan class="italicized">', COIN_NAME, '</tspan></text>'
					'</svg>'
					'<svg y="10%">'
						'<text>This DCoA certifies and guarantees that the original holder was a </text>'
						'<text y="3%">recipient of coin number ', uint256(params.number).toString(), ' (out of ', uint256(params.cap).toString(), ') from the initial minting of </text>'
						'<text y="6%"><tspan class="italicized">', COIN_NAME, '</tspan> fine silver coins minted in 2022 as part of </text>'
						'<text y="9%">the Silver Mare Coin project on /mlp/.</text>'
					'</svg>'
				'</svg>', 
				_generateCoin(), 
			'</svg>'
		));
	}

	/**
	 * @param params describing the token
	 * @return The Base64-encoded data: URI for the SVG image for the token
	 */
	function tokenSvgUri(MetadataBuilder.TokenParams memory params) internal pure returns (string memory) { return tokenSvg(params).toBase64Uri("image/svg+xml"); }
	
	/// @return The SVG for the portion of the token image showing the coin
	function _generateCoin() private pure returns (bytes memory) {
		UFixed24x2 textLength = COIN_RIM_TEXT_R_PCT.mul(VIEW_BOX_SIZE).mul(PI).mul(4);
		return abi.encodePacked(
			'<g>', 
				_generateCoinCircle(COIN_OUTER_R_PCT, COIN_OUTER_STROKE_WIDTH_PCT), 
				'<text y="50%">'
					'<textPath href="#edgeText" lengthAdjust="spacingAndGlyphs" spacing="auto" textLength="', textLength.toBytes(), '">', 
						_generateCoinRimText(), 
					'</textPath>'
				'</text>', 
				_generateCoinCircle(COIN_INNER_R_PCT, COIN_INNER_STROKE_WIDTH_PCT), 
				'<text x="50%" y="60%" class="h1">PONY GOES HERE</text>'
			'</g>'
		);
	}

	/**
	 * @param r the radius of the circle to generate
	 * @param strokeWidth the width of the stroke for the circle
	 * @return SVG `circle` element describing the defined circle
	 */
	function _generateCoinCircle(uint24 r, string memory strokeWidth) private pure returns (bytes memory) {
		return abi.encodePacked(
			'<circle '
				'cx="', COIN_X_PCT.toBytes(), '%" '
				'cy="', COIN_Y_PCT.toBytes(), '%" '
				'r="', uint256(r).toString(), '%" '
				'fill="', COIN_FILL, '" '
				'stroke="', COIN_STROKE, '" '
				'stroke-width="', strokeWidth, '%"/>'
		);
	}

	/// @return result The coin rim text repeated `COIN_RIM_TEXT_COUNT` times (plus an extra `CLOVER` at the end)
	function _generateCoinRimText() private pure returns (bytes memory result) {
		for (uint8 i = 0; i < COIN_RIM_TEXT_COUNT; i++) {
			result = abi.encodePacked(result, COIN_RIM_TEXT);
		}
		result = abi.encodePacked(result, CLOVER);
	}

	/// @return SVG `path` element describing the coin rim text path
	function _generateCoinRimTextPath() private pure returns (bytes memory) {
		UFixed24x2 r = COIN_RIM_TEXT_R_PCT.mul(VIEW_BOX_SIZE);
		UFixed24x2 x = COIN_X_PCT.mul(VIEW_BOX_SIZE);
		UFixed24x2 y = COIN_Y_PCT.mul(VIEW_BOX_SIZE);
		bytes memory doubleRString = r.mul(2).toBytes();
		bytes memory rString = r.toBytes();
		// cx=350 cy=420 r=238
		return abi.encodePacked(
			'<path '
				'id="edgeText" '
				'd="M', x.sub(r).toBytes(), ' ', y.toBytes(), 'a', rString, ' ', rString, ' 1 0 1 ', doubleRString, ' 1 ', rString, ' ', rString, ' 1 0 1-', doubleRString, ' 1"/>'
		);
	}
}