// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISwapPool {
    /// @dev Sets the initial price for pool
    function intialize(uint160 sqrtPriceX96) external;


    /// @dev Adds liquidity for the given recipient/tickLower/tickUpper position
    /// @param recipient The address for which the liquidity will be created

    function mint(address recipient, int24 tickerLower, int24 tickerUpper, uint128 amount) external returns(uint256 amount0, uint256 amount1);


    /// @dev Swap token0 for token1, or token1 for token0
    /// @param recipient The address to receive the output of the swap
    /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
    /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
    /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
    /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
    /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
    /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
    function swap(address recipient, bool zeroForOne, int256 amountSpecified, uint160 sqrtPriceLimitX96) external returns (int256 amount0, int256 amount1);

}