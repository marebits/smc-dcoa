// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Library defining the types NumericParams and StringParams used to simplify the generation of JSON metadata attributes
 * @author Twifag
 */
library MetadataAttribute {
	using Strings for uint256;

	/**
	 * @dev Represents the parameters for numeric metadata; see https://docs.opensea.io/docs/metadata-standards
	 * @param displayType equivalent to `display_type`; possible values are `number`, `boost_percentage`, `boost_number`, or `date` (optional)
	 * @param traitType equivalent to `trait_type`; a user defined string naming the trait (required)
	 * @param value equivalent to `value`; the numeric value of the trait (required)
	 * @param maxValue equivalent to `max_value`; the maximum possible value for the trait type `traitType` (optional)
	 */
	struct NumericParams {
		bytes16 displayType;
		bytes16 traitType;
		uint128 value;
		uint128 maxValue;
	}

	/**
	 * @dev Represents the parameters for string metadata; see https://docs.opensea.io/docs/metadata-standards
	 * @param traitType equivalent to `trait_type`; a user defined string naming the trait (required)
	 * @param value equivalent to `value`; the string value of the trait (required)
	 */
	struct StringParams {
		bytes16 traitType;
		bytes16 value;
	}

	/**
	 * @param params describing either the numeric or string trait
	 * @return JSON object representing the trait
	 */
	function toJsonObject(NumericParams memory params) internal pure returns (bytes memory) {
		return abi.encodePacked(
			'{', 
				_displayType(params.displayType), 
				_maxValue(params.maxValue), 
				_traitType(params.traitType), 
				_value(params.value), 
			'}'
		);
	}
	function toJsonObject(StringParams memory params) internal pure returns (bytes memory) {
		return abi.encodePacked(
			'{', 
				_traitType(params.traitType), 
				_value(params.value), 
			'}'
		);
	}

	/**
	 * @param displayType passed in the {NumericParams}
	 * @return JSON describing the displayType, if provided; otherwise, an empty string
	 */
	function _displayType(bytes16 displayType) private pure returns (bytes memory) { return (displayType == "") ? bytes("") : abi.encodePacked('"display_type":"', displayType, '",'); }

	/**
	 * @param maxValue passed in the {NumericParams}
	 * @return JSON describing the maxValue, if provided; otherwise, an empty string
	 */
	function _maxValue(uint128 maxValue) private pure returns (bytes memory) { return (maxValue == 0) ? bytes("") : abi.encodePacked('"max_value":', uint256(maxValue).toString(), ','); }

	/**
	 * @param traitType passed in the {NumericParams} or {StringParams}
	 * @return JSON describing the traitType
	 */
	function _traitType(bytes16 traitType) private pure returns (bytes memory) { return abi.encodePacked('"trait_type":"', traitType, '",'); }

	/**
	 * @param value passed in the {NumericParams} or {StringParams}
	 * @return JSON describing the value
	 */
	function _value(bytes16 value) private pure returns (bytes memory) { return abi.encodePacked('"value":"', value, '"'); }
	function _value(uint128 value) private pure returns (bytes memory) { return abi.encodePacked('"value":', uint256(value).toString()); }
}