// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ABDKMath64x64.sol";

library TickMath {

    using ABDKMath64x64 for int128;

    /// @dev see https://ethereum.stackexchange.com/questions/113844/how-does-uniswap-v3s-logarithm-library-tickmath-sol-work
    function getTickAtPrice(uint256 price) external pure returns(uint256) {
        int128 priceFixed = ABDKMath64x64.fromUInt(price);
        return priceFixed.log_2().mul(255738958999603826347141).toUInt();
    }

    function getPriceAtTick(uint256 tick) external pure returns(uint256) {
        int128 base = ABDKMath64x64.fromUInt(10001).div(10000);
        return base.pow(tick).toUInt();
    }
}