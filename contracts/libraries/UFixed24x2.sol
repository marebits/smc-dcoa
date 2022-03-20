// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

type UFixed24x2 is uint24;
using UFixed24x2Math for UFixed24x2 global;

library UFixed24x2Math {
	uint24 constant MULTIPLIER = 10**2;

	function _countDigits(uint24 a) private pure returns (uint8 result) {
		while (a > 0) {
			result++;
			a /= 10;
		}
	}
	function _toAsciiInt(uint24 a) private pure returns (bytes1) { return bytes1(uint8(48 + a)); }

	function add(UFixed24x2 a, UFixed24x2 b) internal pure returns (UFixed24x2) { return UFixed24x2.wrap(UFixed24x2.unwrap(a) + UFixed24x2.unwrap(b)); }
	function add(UFixed24x2 a, uint24 b) internal pure returns (UFixed24x2) { return add(a, toUFixed24x2(b)); }

	function equals(UFixed24x2 a, UFixed24x2 b) internal pure returns (bool) { return UFixed24x2.unwrap(a) == UFixed24x2.unwrap(b); }
	function equals(UFixed24x2 a, uint24 b) internal pure returns (bool) { return equals(a, toUFixed24x2(b)); }

	function getDecimals(UFixed24x2 a) internal pure returns (uint8) { return uint8(UFixed24x2.unwrap(a) % MULTIPLIER); }

	function mul(UFixed24x2 a, UFixed24x2 b) internal pure returns (UFixed24x2) { return UFixed24x2.wrap(UFixed24x2.unwrap(a) * UFixed24x2.unwrap(b) / MULTIPLIER); }
	function mul(UFixed24x2 a, uint24 b) internal pure returns (UFixed24x2) { return mul(a, toUFixed24x2(b)); }

	function sub(UFixed24x2 a, UFixed24x2 b) internal pure returns (UFixed24x2) { return UFixed24x2.wrap(UFixed24x2.unwrap(a) + UFixed24x2.unwrap(b)); }
	function sub(UFixed24x2 a, uint24 b) internal pure returns (UFixed24x2) { return sub(a, toUFixed24x2(b)); }

	function toString(UFixed24x2 a) internal pure returns (string memory) {
		if (a.equals(0)) {
			return "0";
		}
		uint8 decimals = a.getDecimals();
		bytes memory fractional;
		uint24 integer = a.toUint24();
		bytes memory whole;

		if (integer > 0) {
			uint8 integerLength = _countDigits(integer);
			whole = new bytes(integerLength);

			while (integer > 0) {
				whole[--integerLength] = _toAsciiInt(integer % 10);
				integer /= 10;
			}
		} else {
			whole = new bytes(1);
			whole[0] = '0';
		}

		if (decimals > 0) {
			if (decimals % 10 > 0) {
				fractional = new bytes(3);
				fractional[2] = _toAsciiInt(decimals % 10);
			} else {
				fractional = new bytes(2);
			}
			decimals /= 10;
			fractional[1] = _toAsciiInt(decimals);
			fractional[0] = '.';
		} else {
			return string(whole);
		}
		return string(abi.encodePacked(whole, fractional));
	}

	function toUFixed24x2(uint24 a) internal pure returns (UFixed24x2) { return UFixed24x2.wrap(a * MULTIPLIER); }

	function toUint24(UFixed24x2 a) internal pure returns (uint24) { return UFixed24x2.unwrap(a) / MULTIPLIER; }
}