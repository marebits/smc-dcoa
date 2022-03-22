// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @title Library simplifying the creation of Base64-encoded data: URIs
 * @author Twifag
 */
library Base64Uri {
	using Base64 for bytes;

	/**
	 * @dev Returns a properly formatted, Base64-encoded data: URI for message `message` and encoded MIME type `mimeType`
	 * @param message to encode in the URI
	 * @param mimeType of the message being encoded
	 * @return A Base64-encoded data: URI
	 */
	function toBase64Uri(string memory message, bytes16 mimeType) internal pure returns (string memory) {
		return string(abi.encodePacked("data:", mimeType, ";base64,", bytes(message).encode()));
	}
}