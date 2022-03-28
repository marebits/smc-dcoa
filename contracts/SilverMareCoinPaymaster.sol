// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./interfaces/ISilverMareCoinDCoA.sol";
import "./interfaces/ISilverMareCoinPaymaster.sol";
import "./KnowsBestPony.sol";
import "./Ownable.sol";
import "@opengsn/contracts/src/interfaces/IPaymaster.sol";
import "@opengsn/contracts/src/interfaces/IRelayHub.sol";
import "@opengsn/contracts/src/interfaces/IRelayRecipient.sol";
import "@opengsn/contracts/src/utils/GsnTypes.sol";
import "@opengsn/contracts/src/utils/GsnUtils.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title The implementation for the {ISilverMareCoinPaymaster} and {IPaymaster} interfaces
 * @notice Slightly modified and extended from @opengsn/contracts/src/BasePaymaster.sol to allow setting {trustedForwarder} in constructor
 * @author Twifag
 */
contract SilverMareCoinPaymaster is Ownable, KnowsBestPony, ISilverMareCoinPaymaster {
	using Address for address;
	using GsnUtils for bytes;

	uint256 public constant CALLDATA_SIZE_LIMIT = 10500;
	uint256 public constant FORWARDER_HUB_OVERHEAD = 50000;
	uint256 public constant POST_RELAYED_CALL_GAS_LIMIT = 110000;
	uint256 public constant PRE_RELAYED_CALL_GAS_LIMIT = 100000;
	address public immutable TRUSTED_RECIPIENT;

	uint256 public constant PAYMASTER_ACCEPTANCE_BUDGET = PRE_RELAYED_CALL_GAS_LIMIT + FORWARDER_HUB_OVERHEAD;

	/// @inheritdoc IPaymaster
	string public constant versionPaymaster = "2.2.6";

	IRelayHub private _relayHub;
	address private _trustedForwarder;

	/// @dev To be used as access control protection for {preRelayedCall} and {postRelayedCall}
	modifier relayHubOnly() {
		if (msg.sender != getHubAddr()) {
			revert CallerIsNotRelayHub(msg.sender, getHubAddr());
		}
		_;
	}

	/// @param trustedRecipient the trusted recipient contract address (should be the SilverMareCoinDCoA contract)
	constructor(address trustedForwarder_, address trustedRecipient) {
		TRUSTED_RECIPIENT = trustedRecipient;
		_setTrustedForwarder(trustedForwarder_);
	}

	receive() external payable {
		if (getHubAddr() == address(0)) {
			revert RelayHubNotSet();
		}
	}

	function _setTrustedForwarder(address forwarder) private { _trustedForwarder = forwarder; }

	/// @inheritdoc IPaymaster
	function postRelayedCall(bytes calldata context, bool success, uint256 gasUseWithoutPost, GsnTypes.RelayData calldata relayData) external view override relayHubOnly {}

	/// @inheritdoc IPaymaster
	function preRelayedCall(GsnTypes.RelayRequest calldata relayRequest, bytes calldata signature, bytes calldata approvalData, uint256 maxPossibleGas)
		external
		view
		override
		relayHubOnly
		returns (bytes memory context, bool revertOnRecipientRevert)
	{
		(signature, approvalData, maxPossibleGas);
		_verifyForwarder(relayRequest);

		if (relayRequest.request.to != TRUSTED_RECIPIENT) {
			revert UntrustedRecipient(relayRequest.request.to);
		} 
		bytes4 methodSignature = relayRequest.request.data.getMethodSig();

		if (methodSignature != ISilverMareCoinDCoA.claimCertificate.selector && methodSignature != ISilverMareCoinDCoA.claimCertificates.selector) {
			revert InvalidFunction(methodSignature);
		}
		return ("", false);
	}

	function setRelayHub(IRelayHub hub) public onlyOwner { _relayHub = hub; }

	function setTrustedForwarder(address forwarder) public onlyOwner { _setTrustedForwarder(forwarder); }

	function withdrawRelayHubDepositTo(uint256 amount, address payable target) public onlyOwner { _relayHub.withdraw(amount, target); }

	/**
	 * @notice This method must be called from {preRelayedCall} to validate that the forwarder is approved by the paymaster as well as by the recipient contract.
	 * @param relayRequest to verify
	 */
	function _verifyForwarder(GsnTypes.RelayRequest calldata relayRequest) public view {
		if (_trustedForwarder != relayRequest.relayData.forwarder) {
			revert UntrustedForwarder(relayRequest.relayData.forwarder);
		}
		bytes memory returnValue = relayRequest.request.to.functionStaticCall(abi.encodeWithSelector(IRelayRecipient.isTrustedForwarder.selector, relayRequest.relayData.forwarder));

		if (returnValue.length != 32) {
			revert RecipientTrustedForwarderCheckBadResponse(relayRequest.request.to, relayRequest.relayData.forwarder);
		} else if (!abi.decode(returnValue, (bool))) {
			revert RecipientUntrustedForwarder(relayRequest.request.to, relayRequest.relayData.forwarder);
		}
	}

	/// @inheritdoc IPaymaster
	function getHubAddr() public view override returns (address) { return address(_relayHub); }

	/// @inheritdoc IPaymaster
	function getRelayHubDeposit() public view override returns (uint256) { return _relayHub.balanceOf(address(this)); }

	/// @inheritdoc IPaymaster
	function trustedForwarder() public view override returns (address) { return _trustedForwarder; }

	/// @inheritdoc IPaymaster
	function getGasAndDataLimits() public pure override returns (IPaymaster.GasAndDataLimits memory limits) {
		limits = IPaymaster.GasAndDataLimits({
			acceptanceBudget: PAYMASTER_ACCEPTANCE_BUDGET, 
			preRelayedCallGasLimit: PRE_RELAYED_CALL_GAS_LIMIT, 
			postRelayedCallGasLimit: POST_RELAYED_CALL_GAS_LIMIT, 
			calldataSizeLimit: CALLDATA_SIZE_LIMIT
		});
	}
}