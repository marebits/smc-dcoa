// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.12;

import "./Base64.sol";

library MetadataBuilder {
	using Base64 for bytes;

	struct TokenMetadataParams {
		uint16 number;
		uint16 cap;
	}

	string constant COIN_NAME = "*The Ride Never Ends*";
	string constant CONTRACT_NAME = "Silver Mare Coin Digital Certificate of Authenticity";
	string constant PROJECT_DESCRIPTOR = "Silver Mare Coin project on /mlp/";
	string constant YEAR_MINTED = "2022";

	function _encodeBase64(string memory message) private pure returns (string memory) { return string(abi.encodePacked("data:application/json;base64,", bytes(message).encodeBase64())); }
	function _getAttributes(TokenMetadataParams memory params) private pure returns (string memory) {
		return string(abi.encodePacked('['
			'{"display_type":"number","trait_type":"Issue","value":', params.number, ',"max_value":', params.cap, '},'
			'{"trait_type":"Minted Year","value":"', YEAR_MINTED, '"},'
			'{"trait_type":"Composition","value":"99.9% Ag"},'
			'{"trait_type":"Mass","value":"1 troy oz"},'
			'{"trait_type":"Diameter","value":"TBD"},'
			'{"trait_type":"Width","value":"TBD"}'
		']'));
	}
	function _getDescription(TokenMetadataParams memory params) private pure returns (string memory) {
		return string(abi.encodePacked(
			'# Digital Certificate of Authenticity (DCoA)\\n'
			'## ', YEAR_MINTED, ' ', COIN_NAME, '\\n\\n'
			'This DCoA certifies and guarantees that the original holder of this token was a recipient of coin number ', params.number, ' (out of ', params.cap, ') '
			'from the initial minting of ', COIN_NAME, ' issued in ', YEAR_MINTED, ' as part of the ', PROJECT_DESCRIPTOR, '.'
		));
	}

	function getContractMetadata(uint16 cap) internal pure returns (string memory) {
		return string(abi.encodePacked('{'
				'"name":"', CONTRACT_NAME, '",'
				'"description":"'
					'A Digital Certificate of Authenticity (DCoA) for the initial minting of ', COIN_NAME, ' silver coins issued in ', YEAR_MINTED, ' '
					'as part of the ', PROJECT_DESCRIPTOR, '.  A total of ', cap, ' coins were minted and sold.",'
				'"symbol":"SMC1 DCoA",'
				'"image":"TBD",'
				'"external_link":"https://4channel.org/mlp/",'
				'"seller_fee_basis_points":0,'
				'"fee_recipient":"0x0000000000000000000000000000000000000000"'
			'}'
		));
	}

	function getContractUri(uint16 cap) internal pure returns (string memory) { return _encodeBase64(getContractMetadata(cap)); }

	function getTokenMetadata(TokenMetadataParams memory params) internal pure returns (string memory) {
		return string(abi.encodePacked(
			'{'
				'"name":"', CONTRACT_NAME, ' #', params.number, '",'
				'"description":"', _getDescription(params), '",'
				'"image":"', SVGBuilder.getTokenSvgUri(params), '",'
				'"image_data":"', SVGBuilder.getTokenSvg(params), '",'
				'"background_color":"cc9cdf",'
				'"attributes": ', _getAttributes(params), 
			'}'
		));
	}

	function getTokenUri(TokenMetadataParams memory params) internal pure returns (string memory) { return _encodeBase64(getTokenMetadata(params)); }
}

library SVGBuilder {
	function getTokenSvg(MetadataBuilder.TokenMetadataParams memory params) internal pure returns (string memory) { return ""; }
	function getTokenSvgUri(MetadataBuilder.TokenMetadataParams memory params) internal pure returns (string memory) { return ""; }
}

// Mint Year ("2022"), Mint Date(?)

/*
DIGITAL CERTIFICATE OF AUTHENTICITY

The issuer of this Digital Certificate of Authenticity certifies and guarantees that the original holder of this token was a recipient of coin # from the initial minting of *The Ride Never Ends* issued in 2022 as part of the Silver Mare Coin project on /mlp/.
Each privately minted, non-monetary *The Ride Never Ends* conforms to the following specifications:

* Composition: 99.9% pure silver
* Diameter: 
* Width: 
* Weight;
*/