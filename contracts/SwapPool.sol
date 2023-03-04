// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/ISwapPoolDeployer.sol";
import "./interfaces/ISwapPool.sol";
import "./libraries/TickMath.sol";

contract SwapPool is ISwapPool {
    address public immutable token0;
    address public immutable token1;
    int24 public immutable tickSpacing;

    struct Slot0 {
        uint160 sqrtPriceX96;
        int24 tick;
    }

    struct ModifyPositionParams {
        // the address that owns the position
        address owner;
        // the lower and upper tick of the position
        int24 tickLower;
        int24 tickUpper;
        // any change in liquidity
        int128 liquidityDelta;
    }

    Slot0 public slot0;

    constructor() {
        int24 _tickSpacing;
        (token0, token1, _tickSpacing) = ISwapPoolDeployer(msg.sender)
            .parameters();
        tickSpacing = _tickSpacing;
    }

    // @dev Get the pool's balance of token0
    function balance0() private view returns (uint256) {
        return _balance(token0);
    }

    // @dev Get the pool's balance of token1
    function balance1() private view returns (uint256) {
        return _balance(token1);
    }

    function _balance(address _token) internal view returns (uint256) {
        (bool success, bytes memory data) = _token.staticcall(
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this))
        );
        require(success && data.length >= 32);
        return abi.decode(data, (uint256));
    }

    function intialize(uint160 sqrtPriceX96) external override {
        int24 tick = TickMath.getTickAtSqrtRatio(sqrtPriceX96);
        slot0 = Slot0({
           sqrtPriceX96: sqrtPriceX96,
           tick : tick 
        });

    }

    function mint(
        address recipient,
        int24 tickerLower,
        int24 tickerUpper,
        uint128 amount
    ) external override returns (uint256 amount0, uint256 amount1) {


    }

    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96
    ) external override returns (int256 amount0, int256 amount1) {}


    /// @dev Effect some changes to a position
    /// @return amount0 the amount of token0 owed to the pool, negative if the pool should pay the recipient
    /// @return amount1 the amount of token1 owed to the pool, negative if the pool should pay the recipient
    function _modifyPosition(ModifyPositionParams memory params) private returns(int256 amount0, int256 amount1) {
        
    }
}
