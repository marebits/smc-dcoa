// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./interfaces/ISilverMareCoinDCoA.sol";
import "./interfaces/ISilverMareCoinPaymaster.sol";
import "./KnowsBestPony.sol";
import "@opengsn/contracts/src/BasePaymaster.sol";
import "@opengsn/contracts/src/utils/GsnTypes.sol";
import "@opengsn/contracts/src/utils/GsnUtils.sol";

/**
 * @title The implementation for the {ISilverMareCoinPaymaster} and {BasePaymaster} interfaces
 * @author Twifag
 */
contract SilverMareCoinPaymaster is BasePaymaster, KnowsBestPony, ISilverMareCoinPaymaster {
	address public immutable TRUSTED_RECIPIENT;

	/// @inheritdoc IPaymaster
	string public constant versionPaymaster = "2.2.6";

	/// @param trustedRecipient the trusted recipient contract address (should be the SilverMareCoinDCoA contract)
	constructor(address trustedRecipient) { TRUSTED_RECIPIENT = trustedRecipient; }

	/// @inheritdoc IPaymaster
	function preRelayedCall(GsnTypes.RelayRequest calldata relayRequest, bytes calldata signature, bytes calldata approvalData, uint256 maxPossibleGas) external view override returns (bytes memory context, bool revertOnRecipientRevert) {
		(signature, approvalData, maxPossibleGas);
		_verifyForwarder(relayRequest);

		if (relayRequest.request.to != TRUSTED_RECIPIENT) {
			revert UntrustedRecipient(relayRequest.request.to);
		} 
		bytes4 methodSignature = GsnUtils.getMethodSig(relayRequest.request.data);

		if (methodSignature != ISilverMareCoinDCoA.claimCertificate.selector) {
			revert InvalidFunction(methodSignature);
		}
		return ("", false);
	}

	/// @inheritdoc IPaymaster
	function postRelayedCall(bytes calldata context, bool success, uint256 gasUseWithoutPost, GsnTypes.RelayData calldata relayData) external pure override {}
}