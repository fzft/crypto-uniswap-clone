// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SwapPool.sol";
import "./interfaces/ISwapPoolDeployer.sol";

contract SwapPoolDeployer is ISwapPoolDeployer {
    struct Parameters {
        address token0;
        address token1;
        int24 tickSpacing;
    }

    Parameters public override parameters;

    function deploy(address token1, address token2, int24 tickSpacing) external returns (address pool) {
        parameters = Parameters(token1, token2, tickSpacing);
        pool = address(new SwapPool{salt: keccak256(abi.encodePacked(token1, token2, tickSpacing))}());
        delete parameters;
    }
}