// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/Strings.sol";

library MetadataAttribute {
	using Strings for uint256;

	struct NumericParams {
		bytes16 displayType;
		bytes16 traitType;
		uint128 value;
		uint128 maxValue;
	}

	struct StringParams {
		bytes16 traitType;
		bytes16 value;
	}

	function _displayType(bytes16 displayType) private pure returns (string memory) { return (displayType == "") ? "" : string(abi.encodePacked('"display_type":"', displayType, '",')); }
	function _maxValue(uint128 maxValue) private pure returns (string memory) { return (maxValue == 0) ? "" : string(abi.encodePacked('"max_value":', uint256(maxValue).toString(), ',')); }
	function _traitType(bytes16 traitType) private pure returns (string memory) { return string(abi.encodePacked('"trait_type":"', traitType, '",')); }
	function _value(bytes16 value) private pure returns (string memory) { return string(abi.encodePacked('"value":"', value, '"')); }
	function _value(uint128 value) private pure returns (string memory) { return string(abi.encodePacked('"value":', uint256(value).toString())); }

	function toJsonObject(NumericParams memory params) internal pure returns (string memory) {
		return string(abi.encodePacked(
			'{', 
				_displayType(params.displayType), 
				_maxValue(params.maxValue), 
				_traitType(params.traitType), 
				_value(params.value), 
			'}'
		));
	}
	function toJsonObject(StringParams memory params) internal pure returns (string memory) {
		return string(abi.encodePacked(
			'{', 
				_traitType(params.traitType), 
				_value(params.value), 
			'}'
		));
	}
}