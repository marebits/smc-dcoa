// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "@opengsn/contracts/src/interfaces/IPaymaster.sol";

/**
 * @title Defines the Silver Mare Coin Paymaster {SilverMareCoinPaymaster} interface
 * @author Twifag
 */
interface ISilverMareCoinPaymaster is IPaymaster {
	/**
	 * @notice Thrown when the caller `caller` is not the `relayHub`; used for access restriction in the {SilverMareCoinPaymaster.relayHubOnly} modifier.
	 * @param caller that called the function
	 * @param relayHub caller was expected to be
	 */
	error CallerIsNotRelayHub(address caller, address relayHub);

	/**
	 * @notice Thrown when an invalid function with signature `signature` is called
	 * @param signature that is invalid
	 */
	error InvalidFunction(bytes4 signature);

	/**
	 * @notice Thrown when {IRelayRecipient.isTrustedForwarder} returns a bad response for recipient `recipient` when checking forwarder `forwarder`
	 * @param recipient of the transaction
	 * @param forwarder value
	 */
	error RecipientTrustedForwarderCheckBadResponse(address recipient, address forwarder);

	/**
	 * @notice Thrown when forwarder `forwarder` is untrusted by recipient `recipient`.  See {IRelayRecipient.isTrustedForwarder}.
	 * @param recipient of the transaction
	 * @param forwarder value
	 */
	error RecipientUntrustedForwarder(address recipient, address forwarder);

	/// @notice Thrown when `relayHub` is not set
	error RelayHubNotSet();

	/**
	 * @notice Thrown when provided forwarder `forwarder` is untrusted.
	 * @param forwarder that is untrusted
	 */
	error UntrustedForwarder(address forwarder);

	/**
	 * @notice Thrown when receiving a call from untrusted recipient `recipient`.
	 * @param recipient that is untrusted
	 */
	error UntrustedRecipient(address recipient);
}