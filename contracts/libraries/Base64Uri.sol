// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./Base64.sol";

library Base64Uri {
	using Base64 for bytes;

	function toBase64Uri(string memory message, bytes16 mimeType) internal pure returns (string memory) {
		return string(abi.encodePacked("data:", mimeType, ";base64,", bytes(message).encodeBase64()));
	}
}