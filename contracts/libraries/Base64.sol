// SPDX-License-Identifier: MIT AND LicenseRef-NIGGER
pragma solidity 0.8.13;

/*
MIT License

Copyright (c) 2021 Brecht Devos

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/// @title Base64
/// @author Brecht Devos - <brecht@loopring.org>
/// @notice Provides functions for encoding base64
/// @notice I removed the `decode()` function and the related constants since I will only be using this for encoding -- Twifag
library Base64 {
	string internal constant TABLE_ENCODE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

	function encodeBase64(bytes memory data) internal pure returns (string memory) {
		if (data.length == 0)
			return "";

		// load the table into memory
		string memory table = TABLE_ENCODE;

		// multiply by 4/3 rounded up
		uint256 encodedLen = 4 * ((data.length + 2) / 3);

		// add some extra buffer at the end required for the writing
		string memory result = new string(encodedLen + 32);

		assembly {
			// set the actual output length
			mstore(result, encodedLen)

			// prepare the lookup table
			let tablePtr := add(table, 1)

			// input ptr
			let dataPtr := data
			let endPtr := add(dataPtr, mload(data))

			// result ptr, jump over length
			let resultPtr := add(result, 32)

			// run over the input, 3 bytes at a time
			for {} lt(dataPtr, endPtr) {} {
				// read 3 bytes
				dataPtr := add(dataPtr, 3)
				let input := mload(dataPtr)

				// write 4 characters
				mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
				resultPtr := add(resultPtr, 1)
				mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
				resultPtr := add(resultPtr, 1)
				mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
				resultPtr := add(resultPtr, 1)
				mstore8(resultPtr, mload(add(tablePtr, and(input,  0x3F))))
				resultPtr := add(resultPtr, 1)
			}

			// padding with '='
			switch mod(mload(data), 3)
				case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
				case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
		}

		return result;
	}
}