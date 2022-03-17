// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

/**
 * @title ContextMixin abstract contract
 * @dev Enables gasless transactions on MATIC.  From https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/ContextMixin.sol
 */
abstract contract ContextMixin {
	function msgSender() internal view returns (address payable sender) {
		if (msg.sender == address(this)) {
			bytes memory array = msg.data;
			uint256 index = msg.data.length;

			assembly { sender := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff) }
		} else {
			sender = payable(msg.sender);
		}
	}
}