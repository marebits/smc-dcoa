// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

type UFixed24x2 is uint24;
using UFixed24x2Math for UFixed24x2 global;

/**
 * @title Library defining the `UFixed24x2` type and the related math/conversion functions.
 * @dev Following the naming as seen in a Solidity blog post, U(nsigned)Fixed24(bit)x2(decimals)
 * Each `UintFixed24x2` is actually a `uint24`, thus the maximum size is (2**24 - 1) / 10**2 = 167,772.15
 * Written but unused functions are commented out below for future use and to reduce gas on deployment
 * @author Twifag
 */
library UFixed24x2Math {
	using UFixed24x2Math for uint24;

	/// @dev base multiplier for the type
	uint24 constant MULTIPLIER = 10**2;

	/***
	 * @dev Adds numbers `a` and `b` together; the first parameter must be a {UFixed24x2} while the second can be either {UFixed24x2} or a `uint24`.
	 * Note that `uint24` values will be converted to UFixed24x2 first using `toUFixed24x2` (multiplying by 100)
	 * @param a first addend
	 * @param b second addend
	 * @return sum of addends `a` and `b`
	 */
	// function add(UFixed24x2 a, UFixed24x2 b) internal pure returns (UFixed24x2) { return UFixed24x2.wrap(UFixed24x2.unwrap(a) + UFixed24x2.unwrap(b)); }
	// function add(UFixed24x2 a, uint24 b) internal pure returns (UFixed24x2) { return add(a, b.toUFixed24x2()); }

	/***
	 * @dev Checks if numbers `a` and `b` are equal; the first parameter must be a {UFixed24x2} while the second can be either {UFixed24x2} or a `uint24`.
	 * Note that `uint24` values will be converted to UFixed24x2 first using `toUFixed24x2` (multiplying by 100)
	 * @param a first number
	 * @param b second number
	 * @return true if the numbers `a` and `b` are equal; otherwise, returns false
	 */
	function equals(UFixed24x2 a, UFixed24x2 b) internal pure returns (bool) { return UFixed24x2.unwrap(a) == UFixed24x2.unwrap(b); }
	function equals(UFixed24x2 a, uint24 b) internal pure returns (bool) { return equals(a, b.toUFixed24x2()); }

	/**
	 * @param a number
	 * @return the decimal portion of the number `a`
	 */
	function getDecimals(UFixed24x2 a) internal pure returns (uint8) { return uint8(UFixed24x2.unwrap(a) % MULTIPLIER); }

	/**
	 * @dev Multiplies numbers `a` and `b` together; the first parameter must be a {UFixed24x2} while the second can be either {UFixed24x2} or a `uint24`.
	 * Note that `uint24` values will be converted to UFixed24x2 first using `toUFixed24x2` (multiplying by 100)
	 * @param a multiplicand
	 * @param b multiplier
	 * @return product of factors `a` and `b`
	 */
	function mul(UFixed24x2 a, UFixed24x2 b) internal pure returns (UFixed24x2) { return UFixed24x2.wrap(UFixed24x2.unwrap(a) * UFixed24x2.unwrap(b) / MULTIPLIER); }
	function mul(UFixed24x2 a, uint24 b) internal pure returns (UFixed24x2) { return mul(a, b.toUFixed24x2()); }

	/**
	 * @dev Subtracts number `b` from `a`; the first parameter must be a {UFixed24x2} while the second can be either {UFixed24x2} or a `uint24`.
	 * Note that `uint24` values will be converted to UFixed24x2 first using `toUFixed24x2` (multiplying by 100)
	 * @param a minuend
	 * @param b subtrahend
	 * @return difference of numbers `a` and `b`
	 */
	function sub(UFixed24x2 a, UFixed24x2 b) internal pure returns (UFixed24x2) { return UFixed24x2.wrap(UFixed24x2.unwrap(a) + UFixed24x2.unwrap(b)); }
	// function sub(UFixed24x2 a, uint24 b) internal pure returns (UFixed24x2) { return sub(a, b.toUFixed24x2()); }

	/**
	 * @param a number
	 * @return the number `a` converted to a `bytes` representation, including the decimal point and any fractional portion (if required)
	 */
	function toBytes(UFixed24x2 a) internal pure returns (bytes memory) {
		if (a.equals(0)) {
			return bytes("0");
		}
		uint8 decimals = a.getDecimals();
		bytes memory fractional;
		uint24 integer = a.toUint24();
		bytes memory whole;

		if (integer > 0) {
			uint8 integerLength = _countDigits(integer);
			whole = new bytes(integerLength);

			while (integer > 0) {
				whole[--integerLength] = _toChar(integer % 10);
				integer /= 10;
			}
		} else {
			whole = new bytes(1);
			whole[0] = '0';
		}

		if (decimals > 0) {
			if (decimals % 10 > 0) {
				fractional = new bytes(3);
				fractional[2] = _toChar(decimals % 10);
			} else {
				fractional = new bytes(2);
			}
			decimals /= 10;
			fractional[1] = _toChar(decimals);
			fractional[0] = '.';
		} else {
			return whole;
		}
		return abi.encodePacked(whole, fractional);
	}

	/**
	 * @param a number
	 * @return the number `a` converted to a `string` representation, including the decimal point and any fractional portion (if required)
	 */
	// function toString(UFixed24x2 a) internal pure returns (string memory) { return string(toBytes(a)); }

	/**
	 * @param a number
	 * @return the `uint24` `a` represented as a {UFixed24x2} (multiplying by 100)
	 */
	function toUFixed24x2(uint24 a) internal pure returns (UFixed24x2) { return UFixed24x2.wrap(a * MULTIPLIER); }

	/**
	 * @param a number
	 * @return the {UFixed24x2} `a` represented as a uint24 (dividing by 100 and flooring the result, eliminating any fractional portion)
	 */
	function toUint24(UFixed24x2 a) internal pure returns (uint24) { return UFixed24x2.unwrap(a) / MULTIPLIER; }

	/**
	 * @param a number
	 * @return result the number of digits contained within the number `a`
	 */
	function _countDigits(uint24 a) private pure returns (uint8 result) {
		while (a > 0) {
			result++;
			a /= 10;
		}
	}

	/**
	 * @dev Converts a value stored as a single digit integer (i.e., 4) to its single character equivalent (i.e., '4')
	 * @param a number
	 * @return the number `a` represented as `bytes1`; that is, a single character
	 */
	function _toChar(uint24 a) private pure returns (bytes1) { return bytes1(uint8(48 + a)); }
}