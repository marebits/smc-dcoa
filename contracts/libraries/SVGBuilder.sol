// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./Base64Uri.sol";
import "./MetadataBuilder.sol";
import { UFixed24x2, UFixed24x2Math } from "./UFixed24x2.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

library SVGBuilder {
	using Base64Uri for string;
	using Strings for uint256;

	bytes constant CLOVER = abi.encodePacked(unicode'🍀︎');
	uint24 constant COIN_DELTA_R_PCT = 4;
	string constant COIN_FILL = "#e1e1e1";
	string constant COIN_INNER_STROKE_WIDTH_PCT = "2";
	uint24 constant COIN_OUTER_R_PCT = 38;
	string constant COIN_OUTER_STROKE_WIDTH_PCT = "1";
	bytes constant COIN_RIM_TEXT = abi.encodePacked(CLOVER, " MARES ");
	uint8 constant COIN_RIM_TEXT_COUNT = 35;
	string constant COIN_STROKE = "#b5b5b5";
	UFixed24x2 constant COIN_X_PCT = UFixed24x2.wrap(50);
	string constant COIN_X_PCT_STRING = "50";
	UFixed24x2 constant COIN_Y_PCT = UFixed24x2.wrap(60);
	string constant COIN_Y_PCT_STRING = "60";
	uint24 constant VIEW_BOX_SIZE = 700;

	uint24 constant COIN_INNER_R_PCT = COIN_OUTER_R_PCT - 2 * COIN_DELTA_R_PCT;
	UFixed24x2 constant COIN_RIM_TEXT_R_PCT = UFixed24x2.wrap(COIN_OUTER_R_PCT - COIN_DELTA_R_PCT);
	
	function _generateCoin() private pure returns (bytes memory) {
		return abi.encodePacked(
			'<g>', 
				_generateCoinCircle(COIN_OUTER_R_PCT, COIN_OUTER_STROKE_WIDTH_PCT), 
				'<text y="50%">'
					'<textPath href="#edgeText" spacing="auto">', 
						_generateCoinRimText(), 
					'</textPath>'
				'</text>', 
				_generateCoinCircle(COIN_INNER_R_PCT, COIN_INNER_STROKE_WIDTH_PCT), 
				'<text x="50%" y="60%" class="h1">PONY GOES HERE</text>'
			'</g>'
		);
	}

	function _generateCoinCircle(uint24 r, string memory strokeWidth) private pure returns (bytes memory) {
		return abi.encodePacked(
			'<circle '
				'cx="', COIN_X_PCT_STRING, '%" '
				'cy="', COIN_Y_PCT_STRING, '%" '
				'r="', uint256(r).toString(), '%" '
				'fill="', COIN_FILL, '" '
				'stroke="', COIN_STROKE, '" '
				'stroke-width="', strokeWidth, '%"/>'
		);
	}

	function _generateCoinRimText() private pure returns (bytes memory result) {
		for (uint8 i = 0; i < COIN_RIM_TEXT_COUNT; i++) {
			result = abi.encodePacked(result, COIN_RIM_TEXT);
		}
		result = abi.encodePacked(result, CLOVER);
	}

	function _generateCoinRimTextPath() private pure returns (bytes memory) {
		UFixed24x2 r = COIN_RIM_TEXT_R_PCT.mul(VIEW_BOX_SIZE);
		UFixed24x2 x = COIN_X_PCT.mul(VIEW_BOX_SIZE);
		UFixed24x2 y = COIN_Y_PCT.mul(VIEW_BOX_SIZE);
		string memory doubleRString = r.mul(2).toString();
		string memory rString = r.toString();
		// cx=350 cy=420 r=238
		return abi.encodePacked(
			'<path '
				'id="edgeText" '
				'd="M', x.sub(r).toString(), ' ', y.toString(), 'a', rString, ' ', rString, ' 1 0 1 ', doubleRString, ' 1 ', rString, ' ', rString, ' 1 0 1-', doubleRString, ' 1"/>'
		);
	}

	function tokenSvg(MetadataBuilder.TokenParams memory params) internal pure returns (string memory) {
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
				'<defs>', 
					_generateCoinRimTextPath(), 
				'</defs>'
				'<rect width="100%" height="100%" fill="#f1c549" rx="3%"/>'
				'<svg id="main" x="50%">'
					'<svg y="3%">'
						'<text class="h1">Digital Certificate of Authenticity (DCoA)</text>'
						'<text y="3%" class="h2">2022 <tspan class="italicized">The Ride Never Ends</tspan></text>'
					'</svg>'
					'<svg y="10%">'
						'<text>This DCoA certifies and guarantees that the original holder was a </text>'
						'<text y="3%">recipient of coin number ', uint256(params.number).toString(), ' (out of ', uint256(params.cap).toString(), ') from the initial minting of </text>'
						'<text y="6%"><tspan class="italicized">The Ride Never Ends</tspan> fine silver coins minted in 2022 as part of </text>'
						'<text y="9%">the Silver Mare Coin project on /mlp/.</text>'
					'</svg>'
				'</svg>', 
				_generateCoin(), 
			'</svg>'
		));
	}
	function tokenSvgUri(MetadataBuilder.TokenParams memory params) internal pure returns (string memory) { return tokenSvg(params).toBase64Uri("image/svg+xml"); }
}