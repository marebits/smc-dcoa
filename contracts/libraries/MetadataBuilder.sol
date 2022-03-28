// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./Base64Uri.sol";
import "./MetadataAttribute.sol";
import "./SVGBuilder.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Library grouping functions used to generate metadata for the contract and individual tokens.
 * @author Twifag
 */
library MetadataBuilder {
	using Base64Uri for string;
	using MetadataAttribute for MetadataAttribute.NumericParams;
	using MetadataAttribute for MetadataAttribute.StringParams;
	using Strings for uint256;

	string internal constant COIN_NAME = "*The Ride Never Ends*";
	string internal constant CONTRACT_NAME = "Silver Mare Coin Digital Certificate of Authenticity";
	string internal constant TITLE = string(abi.encodePacked(
		"# Digital Certificate of Authenticity (DCoA)\\n\\n"
		"## ", YEAR_MINTED, " ", COIN_NAME, "\\n\\n"
		"## One Ounce Fine Silver\\n\\n"
	));
	string internal constant MIME_TYPE = "application/json";
	string internal constant YEAR_MINTED = "2022";
	string internal constant PROJECT_DESCRIPTOR = string(abi.encodePacked(
		"from the initial minting of ", COIN_NAME, " fine silver coins minted in ", YEAR_MINTED, " as part of the Silver Mare Coin project on /mlp/."
	));

	/**
	 * @dev see https://docs.opensea.io/docs/contract-level-metadata
	 * @param cap maximum number of coins to be issued
	 * @return The Base64-encoded data: URI containing the contract's metadata
	 */
	function contractUri(uint16 cap) public pure returns (string memory) { return _encodeBase64(contractMetadata(cap)); }

	/**
	 * @param number of the token
	 * @param cap maximum number of tokens
	 * @return The Base64-encoded data: URI containing the token's metadata
	 */
	function tokenUri(uint16 number, uint16 cap) public pure returns (string memory) { return _encodeBase64(tokenMetadata(number, cap)); }

	/**
	 * @param cap maximum number of coins to be issued
	 * @return The JSON metadata for the contract
	 */
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

	/**
	 * @param number of the token
	 * @param cap maximum number of tokens
	 * @return The JSON metadata for the token
	 */
	function tokenMetadata(uint16 number, uint16 cap) internal pure returns (string memory) {
		return string(abi.encodePacked(
			'{'
				'"name":"', CONTRACT_NAME, ' #', uint256(number).toString(), '/', uint256(cap).toString(), '",'
				'"description":"', _tokenDescription(number, cap), '",'
				'"image":"', SVGBuilder.tokenSvgUri(number, cap), '",'
				'"background_color":"cc9cdf",'
				'"attributes": ', _tokenAttributes(number, cap), 
			'}'
		));
	}

	/**
	 * @param message to encode
	 * @return A Base64-encoded data: URI for the message `message`
	 */
	function _encodeBase64(string memory message) private pure returns (string memory) { return message.toBase64Uri(MIME_TYPE); }

	/**
	 * @param cap maximum number of coins to be issued
	 * @return The description of the contract itself
	 */
	function _contractDescription(uint16 cap) private pure returns (bytes memory) {
		return abi.encodePacked(
			TITLE, 'The tokens issued by this contract guarantee that the original holder was a recipient of a coin ', PROJECT_DESCRIPTOR, '  A total of ', uint256(cap).toString(), 
			' coins were minted and sold.'
		);
	}

	/**
	 * @param number of the token
	 * @param cap maximum number of tokens
	 * @return The metadata attributes for the token as a JSON array
	 */
	function _tokenAttributes(uint16 number, uint16 cap) private pure returns (bytes memory) {
		return abi.encodePacked('[', 
			MetadataAttribute.NumericParams({displayType: "number", traitType: "Issue", value: number, maxValue: cap}).toJsonObject(), 
			MetadataAttribute.StringParams({traitType: "Minted Year", value: YEAR_MINTED}).toJsonObject(), 
			MetadataAttribute.StringParams({traitType: "Composition", value: "99.9% Ag"}).toJsonObject(), 
			MetadataAttribute.StringParams({traitType: "Mass", value: "1 troy oz"}).toJsonObject(), 
			MetadataAttribute.StringParams({traitType: "Diameter", value: "39 mm"}).toJsonObject(), 
			MetadataAttribute.StringParams({traitType: "Thickness", value: "0.12 in"}).toJsonObject(), 
		']');
	}

	/**
	 * @param number of the token
	 * @param cap maximum number of tokens
	 * @return The description for the token
	 */
	function _tokenDescription(uint16 number, uint16 cap) private pure returns (bytes memory) {
		return abi.encodePacked(
			TITLE, "This DCoA certifies and guarantees that the original holder was a recipient of coin number ", 
			uint256(number).toString(), " (out of ", uint256(cap).toString(), ") ", PROJECT_DESCRIPTOR
		);
	}
}

// Mint Year ("2022"), Mint Date(?)
// to do dates: {"display_type":"date","trait_type":"Mint Date","value":UNIXEPOCHSECONDS}