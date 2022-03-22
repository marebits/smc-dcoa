// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

/**
 * @title Defines the Silver Mare Coin Digital Certificate of Authenticity {SilverMareCoinDCoA} interface
 * @author Twifag
 */
interface ISilverMareCoinDCoA {
	/**
	 * @notice Emitted when the address `by` claims the token with the given `id`.
	 * @param by whom the token is claimed
	 * @param id of the token claimed
	 */
	event CertificateClaimed(address indexed by, uint16 indexed id);

	/**
	 * @notice Emitted whenever a DCoA is minted as a signal to online token marketplaces that the metadata for this token is immutable and frozen.
	 * @dev See https://docs.opensea.io/docs/metadata-standards#freezing-metadata
	 * @param uri to be marked as permanent
	 * @param tokenId that has the permanent URI
	 */
	event PermanentURI(string uri, uint256 indexed tokenId);

	/**
	 * @notice Thrown when a certificate has already been claimed.
	 * @param number for which a certificate has already been claimed
	 */
	error CertificateAlreadyClaimed(uint16 number);

	/**
	 * @notice Thrown when a given certificate number `number` is lower than the floor `floor` or higher than the cap `cap`
	 * @param number that is invalid
	 * @param floor minimum allowed value
	 * @param cap maximum allowed value
	 */
	error CertificateNumberOutOfRange(uint16 number, uint16 floor, uint16 cap);

	/**
	 * @notice Thrown when a given signature `signature` doesn't match the {certificateSigningHash} for certificate number `number` as signed by {SIGNER}
	 * @param number of certificate for which claim attempt was made
	 * @param signature that was invalid
	 */
	error InvalidSignature(uint16 number, bytes signature);

	/**
	 * @notice Verifies signature `signature` against the {certificateSigningHash} for certificate number `number` was signed by {SIGNER} and then issues a token if everything is correct.
	 * @dev Emits a {CertificateClaimed} event when successful
	 * @param number of the certificate to claim
	 * @param signature provided to claim the certificate
	 */
	function claimCertificate(uint16 number, bytes calldata signature) external;

	/// @return the maximum allowable certificate number `number`
	function cap() external view returns (uint16);

	/**
	 * @notice Can be used to retrieve the signing hash to be signed by the delegated {SIGNER}
	 * @param number of the contract to retrieve the signing hash
	 * @return the signing hash to be signed by the {SIGNER}
	 */
	function certificateSigningHash(uint16 number) external view returns (bytes32);

	/** 
	 * @dev See https://docs.opensea.io/docs/contract-level-metadata
	 * @return the Uniform Resource Indicator (URI) for this contract
	 */
	function contractURI() external view returns (string memory);

	/**
	 * @param number of the certificate to check claim status
	 * @return true if the given certificate number `number` has already been claimed; otherwise, returns false
	 */
	function isCertificateClaimed(uint16 number) external view returns (bool);

	/// @return the authorized `SIGNER` 
	function SIGNER() external view returns (address);

	/// @return the minimum allowable certificate number `number`
	function floor() external pure returns (uint16);
}