// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISwapPoolDeployer {
    function parameters() external view returns (address token0, address token1, int24 tickSpacing);
}