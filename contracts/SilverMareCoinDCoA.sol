// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.12;

import "./KnowsBestPony.sol";
// import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface ISilverMareCoinDCoA {}

/**
 * @title The implementation for the Mare Bits Locker
 * @author Twifag
 */
contract SilverMareCoinDCoA is ERC721Enumerable, KnowsBestPony, ISilverMareCoinDCoA {
	using Strings for uint256;

	constructor(string memory name, string memory symbol) ERC721(name, symbol) {}
}