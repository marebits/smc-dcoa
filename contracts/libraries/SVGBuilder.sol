// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./Base64Uri.sol";
import "./MetadataBuilder.sol";

library SVGBuilder {
	using Base64Uri for string;

	function tokenSvg(MetadataBuilder.TokenParams memory params) internal pure returns (string memory) {
		return "";
	}
	function tokenSvgUri(MetadataBuilder.TokenParams memory params) internal pure returns (string memory) { return tokenSvg(params).toBase64Uri("image/svg+xml"); }
}