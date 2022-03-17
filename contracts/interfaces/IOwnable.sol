// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/**
 * @title Ownable abstract contract
 * @dev Represents the [ERC-173](https://eips.ethereum.org/EIPS/eip-173) specification
 */
interface IOwnable is IERC165 {
	/// @notice This emits when ownership of a contract changes.
	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	/// @notice Thrown when called by any account other than the owner.
	error CallerIsNotOwner(address caller, address owner);

	/// @notice Get the address of the owner
	/// @return The address of the owner.
	function owner() view external returns(address);

	/**
	 * @notice Transfers ownership of the contract to a new account (`newAccount`).
	 * @dev Can only be called by the current owner.
	 * @param newOwner address of the new owner
	 */
	function transferOwnership(address newOwner) external;
}