// SPDX-License-Identifier: MIT
//  _____     _ _         _         _
// |_   _|_ _(_) |_____  | |   __ _| |__ ___
//   | |/ _` | | / / _ \ | |__/ _` | '_ (_-<
//   |_|\__,_|_|_\_\___/ |____\__,_|_.__/__/

pragma solidity ^0.8.20;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// An ERC20 token for creating a 'failed' status
contract FailWhenBridgeBackCanonical is ERC20 {
    mapping(address minter => bool hasMinted) public minters;

    error HasMinted();

    constructor(string memory name, string memory symbol) ERC20(name, symbol) { }

    function mint(address to) public {
        if (minters[msg.sender]) {
            revert HasMinted();
        }

        minters[msg.sender] = true;
        _mint(to, 50 * (10 ** decimals()));
    }

    // When canonical token, 'safeTransfer()' is called
    //  - in receiveToken() - it will fail.
    function safeTransfer(address, uint256) public pure returns (bool) {
        revert("Cannot bridge back to canonical (intentional).");
    }
}
