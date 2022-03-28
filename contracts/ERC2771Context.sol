// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (metatx/ERC2771Context.sol)
pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/Context.sol";

/**
 * @dev Modified version of original OpenZeppelin implementation to allow changing trustedForwarder
 * @author Twifag (of modifications)
 */
abstract contract ERC2771Context is Context {
	/// @dev needed for OpenGSN compatibility
	string public constant versionRecipient = "2.2.6";
	address internal _trustedForwarder;

	constructor(address trustedForwarder) { _trustedForwarder = trustedForwarder; }

	/**
	 * @notice Sets the trusted forwarded to the address `forwarder`
	 * @dev Executing this function should be restricted to only the owner of the implementing contract!
	 * @param forwarder the address that will be the new trusted forwarder
	 */
	function setTrustedForwarder(address forwarder) public virtual;

	function isTrustedForwarder(address forwarder) public view virtual returns (bool) { return forwarder == _trustedForwarder; }

	function _msgData() internal view virtual override returns (bytes calldata) { return isTrustedForwarder(msg.sender) ? msg.data[:msg.data.length - 20] : super._msgData(); }

	function _msgSender() internal view virtual override returns (address sender) {
		if (isTrustedForwarder(msg.sender)) {
			assembly {sender := shr(96, calldataload(sub(calldatasize(), 20)))}
		} else {
			sender = super._msgSender();
		}
	}
}