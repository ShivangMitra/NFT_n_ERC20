// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/security/Pausable.sol";
import "openzeppelin-solidity/contracts/access/AccessControl.sol";
import "openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "openzeppelin-solidity/contracts/utils/Counters.sol";

contract KrionNFT is ERC721, Pausable, AccessControl, ERC721Burnable {
    IERC20 public tokenAddress;

    uint256 public rate = 100 * 10**18;

    using Counters for Counters.Counter;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor(address _tokenAddress) ERC721("KrionNFT", "KFT") {
        tokenAddress = IERC20(_tokenAddress);

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function withdrawToken() public onlyRole(DEFAULT_ADMIN_ROLE) {
        tokenAddress.transfer(
            msg.sender,
            tokenAddress.balanceOf(address(this))
        );
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint() public {
        tokenAddress.transferFrom(msg.sender, address(this), rate);

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
