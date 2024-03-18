// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract Counter is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20PausableUpgradeable,
    OwnableUpgradeable,
    ERC20PermitUpgradeable,
    UUPSUpgradeable
{
    mapping(address => bool) public hasClaimedAirdrop;
    uint256 public airdropAmount;
    uint256 public minimumBalanceToClaim;

    constructor() {
        _disableInitializers();
    }

    function initialize(
        address initialOwner,
        uint256 _airdropAmount,
        uint256 _minimumBalanceToClaim
    ) public initializer {
        __ERC20_init("Counter", "MTK");
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __Ownable_init(initialOwner);
        transferOwnership(initialOwner);
        __ERC20Permit_init("Counter");
        __UUPSUpgradeable_init();

        airdropAmount = _airdropAmount;
        minimumBalanceToClaim = _minimumBalanceToClaim;
    }

    function claimAirdrop() public {
        require(
            balanceOf(msg.sender) >= minimumBalanceToClaim,
            "Your balance is below the minimum required to claim the airdrop"
        );
        require(
            !hasClaimedAirdrop[msg.sender],
            "You have already claimed the airdrop"
        );

        _mint(msg.sender, airdropAmount);
        hasClaimedAirdrop[msg.sender] = true;
    }

    function withdrawRemainingTokens() public onlyOwner {
        uint256 remainingTokens = balanceOf(address(this));
        require(remainingTokens > 0, "No remaining tokens to withdraw");

        _transfer(address(this), owner(), remainingTokens);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20Upgradeable, ERC20PausableUpgradeable) {
        super._update(from, to, value);
    }
}
