// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.12;

import "./Base64Uri.sol";
import "./MetadataBuilder.sol";

library SVGBuilder {
	using Base64Uri for string;

	function tokenSvg(MetadataBuilder.MetadataParams memory params) internal pure returns (string memory) {
		return "";
	}
	function tokenSvgUri(MetadataBuilder.MetadataParams memory params) internal pure returns (string memory) { return tokenSvg(params).toBase64Uri("image/svg+xml"); }
}