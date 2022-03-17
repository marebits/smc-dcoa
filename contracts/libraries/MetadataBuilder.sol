// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.12;

import "./Base64Uri.sol";
import "./SVGBuilder.sol";

library MetadataBuilder {
	string internal constant COIN_NAME = "*The Ride Never Ends*";
	string internal constant CONTRACT_NAME = "Silver Mare Coin Digital Certificate of Authenticity";
	string internal constant PROJECT_DESCRIPTOR = "Silver Mare Coin project on /mlp/";
	string internal constant YEAR_MINTED = "2022";

	using Base64Uri for string;

	struct MetadataParams {
		uint16 number;
		uint16 cap;
	}

	function _encodeBase64(string memory message) private pure returns (string memory) { return message.toBase64Uri("application/json"); }
	function _contractDescription(uint16 cap) private pure returns (string memory) {
		return string(abi.encodePacked(
			'A Digital Certificate of Authenticity (DCoA) for the initial minting of ', COIN_NAME, ' silver coins issued in ', YEAR_MINTED, 'as part of the ', PROJECT_DESCRIPTOR, '.  '
			'A total of ', cap, ' coins were minted and sold.'
		));
	}
	function _tokenAttributes(MetadataParams memory params) private pure returns (string memory) {
		return string(abi.encodePacked('['
			'{"display_type":"number","trait_type":"Issue","value":', params.number, ',"max_value":', params.cap, '},'
			'{"trait_type":"Minted Year","value":"', YEAR_MINTED, '"},'
			'{"trait_type":"Composition","value":"99.9% Ag"},'
			'{"trait_type":"Mass","value":"1 troy oz"},'
			'{"trait_type":"Diameter","value":"TBD"},'
			'{"trait_type":"Width","value":"TBD"}'
		']'));
	}
	function _tokenDescription(MetadataParams memory params) private pure returns (string memory) {
		return string(abi.encodePacked(
			'# Digital Certificate of Authenticity (DCoA)\\n\\n'
			'## ', YEAR_MINTED, ' ', COIN_NAME, '\\n\\n'
			'This DCoA certifies and guarantees that the original holder was a recipient of coin number ', params.number, ' (out of ', params.cap, ') from the initial minting of ', COIN_NAME, 
			' issued in ', YEAR_MINTED, ' as part of the ', PROJECT_DESCRIPTOR, '.'
		));
	}

	function contractMetadata(uint16 cap) internal pure returns (string memory) {
		return string(abi.encodePacked('{'
				'"name":"', CONTRACT_NAME, '",'
				'"description":"', _contractDescription(cap), '",'
				'"symbol":"SMC1 DCoA",'
				'"image":"TBD",'
				'"external_link":"https://4channel.org/mlp/",'
				'"seller_fee_basis_points":0,'
				'"fee_recipient":"0x0000000000000000000000000000000000000000"'
			'}'
		));
	}

	function contractUri(uint16 cap) internal pure returns (string memory) { return _encodeBase64(contractMetadata(cap)); }

	function tokenMetadata(MetadataParams memory params) internal pure returns (string memory) {
		return string(abi.encodePacked(
			'{'
				'"name":"', CONTRACT_NAME, ' #', params.number, '",'
				'"description":"', _tokenDescription(params), '",'
				'"image":"', SVGBuilder.tokenSvgUri(params), '",'
				'"background_color":"cc9cdf",'
				'"attributes": ', _tokenAttributes(params), 
			'}'
		));
	}

	function tokenUri(MetadataParams memory params) internal pure returns (string memory) { return _encodeBase64(tokenMetadata(params)); }
}

// Mint Year ("2022"), Mint Date(?)
// to do dates: {"display_type":"date","trait_type":"Mint Date","value":UNIXEPOCHSECONDS}