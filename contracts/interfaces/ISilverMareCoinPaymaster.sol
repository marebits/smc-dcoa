// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

/**
 * @title Defines the Silver Mare Coin Paymaster {SilverMareCoinPaymaster} interface
 * @author Twifag
 */
interface ISilverMareCoinPaymaster {
	/**
	 * @notice Thrown when an invalid function with signature `signature` is called
	 * @param signature that is invalid
	 */
	error InvalidFunction(bytes4 signature);

	/**
	 * @notice Thrown when receiving a call from untrusted recipient `recipient`.
	 * @param recipient that is untrusted
	 */
	error UntrustedRecipient(address recipient);
}