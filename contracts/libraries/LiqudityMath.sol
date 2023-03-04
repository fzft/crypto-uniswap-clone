// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ABDKMath64x64.sol";

library LiquidityMath {
    using ABDKMath64x64 for int128;

    /// @dev
    /// @param x represent amount of token0
    /// @param priceA squre root of Pa
    /// @param priceB squre root of Pb
    function getLiquidityForX(
        uint256 x,
        uint256 priceA,
        uint256 priceB
    ) internal pure returns (uint256) {
        int128 xFixed = ABDKMath64x64.fromUInt(x);
        int128 sqrtPriceAFixed = ABDKMath64x64.fromUInt(priceA).sqrt();
        int128 sqrtPriceBFixed = ABDKMath64x64.fromUInt(priceB).sqrt();
        int128 intermediate = sqrtPriceBFixed.sub(sqrtPriceAFixed);
        return
            xFixed
                .mul(sqrtPriceAFixed)
                .mul(sqrtPriceBFixed)
                .div(intermediate)
                .toUInt();
    }

    /// @dev
    /// @param y represent amount of token1
    /// @param priceA squre root of Pa
    /// @param priceB squre root of Pb
    function getLiquidityForY(
        uint256 y,
        uint256 priceA,
        uint256 priceB
    ) internal pure returns (uint256) {
        int128 yFixed = ABDKMath64x64.fromUInt(y);
        int128 sqrtPriceAFixed = ABDKMath64x64.fromUInt(priceA).sqrt();
        int128 sqrtPriceBFixed = ABDKMath64x64.fromUInt(priceB).sqrt();
        int128 intermediate = sqrtPriceBFixed.sub(sqrtPriceAFixed);
        return yFixed.div(intermediate).toUInt();
    }

    /// @dev
    /// @param x represent amount of token0
    /// @param y ...
    /// @param price ...
    /// @param priceA squre root of Pa
    /// @param priceB squre root of Pb
    function getLiquidity(
        uint256 x,
        uint256 y,
        uint256 price,
        uint256 priceA,
        uint256 priceB
    ) internal pure returns (uint256 liquidity) {
        if (price <= priceA) {
            liquidity = getLiquidityForX(x, priceA, priceB);
        } else if (price < priceB) {
            uint256 liquidity0 = getLiquidityForX(x, priceA, priceB);
            uint256 liquidity1 = getLiquidityForY(y, priceA, priceB);
            if (liquidity0 > liquidity1) {
                liquidity = liquidity1;
            } else {
                liquidity = liquidity0;
            }
        } else {
            liquidity = getLiquidityForY(y, priceA, priceB);
        }
    }

    /// @dev if the price is outside the range, use the range endpoints instead
    function calculateX(
        uint256 liquidity,
        uint256 price,
        uint256 priceA,
        uint256 priceB
    ) internal pure returns (uint256) {
        uint256 tempP = _getprice(price, priceA, priceB);
        int128 tempPFixed = ABDKMath64x64.fromUInt(tempP).sqrt();
        int128 sqrtPriceBFixed = ABDKMath64x64.fromUInt(priceB).sqrt();
        int128 liquidityFiexd = ABDKMath64x64.fromUInt(liquidity);
        int128 intermediate = sqrtPriceBFixed.sub(tempPFixed);
        return
            liquidityFiexd
                .mul(intermediate)
                .div(tempPFixed)
                .div(sqrtPriceBFixed)
                .toUInt();
    }

    /// @dev if the price is outside the range, use the range endpoints instead
    function calculateY(
        uint256 liquidity,
        uint256 price,
        uint256 priceA,
        uint256 priceB
    ) internal pure returns (uint256) {
        uint256 tempP = _getprice(price, priceA, priceB);
        int128 tempPFixed = ABDKMath64x64.fromUInt(tempP).sqrt();
        int128 sqrtPriceAFixed = ABDKMath64x64.fromUInt(priceA).sqrt();
        int128 liquidityFiexd = ABDKMath64x64.fromUInt(liquidity);
        int128 intermediate = tempPFixed.sub(sqrtPriceAFixed);
        return
            liquidityFiexd
                .mul(intermediate)
                .toUInt();
    }

    /// @dev calculate price lower boundary
    function calculatepriceA(uint256 liquidity, uint256 price , uint256 amountY) internal pure returns(uint256) {
        int128 sqrtPrice = ABDKMath64x64.fromUInt(price).sqrt();
        int128 amountYFixed = ABDKMath64x64.fromUInt(amountY);
        int128 liquidityFixed = ABDKMath64x64.fromUInt(liquidity);
        int128 intermediate = amountYFixed.div(liquidityFixed);
        return sqrtPrice.sub(intermediate).toUInt();
    }

    /// @dev calculate price upper boundary
    function calculatepriceB(uint256 liquidity, uint256 price, uint256 amountX) internal pure returns(uint256) {
        int128 sqrtPrice = ABDKMath64x64.fromUInt(price).sqrt();
        int128 liquidityFixed = ABDKMath64x64.fromUInt(liquidity);
        int128 amountXFixed = ABDKMath64x64.fromUInt(amountX);
        int128 intermediate1 = sqrtPrice.mul(amountXFixed);
        int128 intermediate2 = amountXFixed.sub(intermediate1);
        return liquidityFixed.mul(sqrtPrice).div(intermediate2).toUInt();
    }

    /// @dev calculate price lower boundary skip liquidity
    function calculatepriceA2(uint256 price, uint256 priceB, uint256 amountX, uint256 amountY) internal pure returns(uint256) {
        int128 sqrtPrice = ABDKMath64x64.fromUInt(price).sqrt();
        int128 sqrtPriceB = ABDKMath64x64.fromUInt(priceB).sqrt();
        int128 amountXFixed = ABDKMath64x64.fromUInt(amountX);
        int128 amountYFixed = ABDKMath64x64.fromUInt(amountY);
        int128 intermediate1 = sqrtPriceB.mul(amountXFixed);
        int128 intermediate2 = amountXFixed.div(intermediate1);
        int128 intermediate3 = sqrtPrice.mul(amountXFixed);
        int128 intermediate4 = amountYFixed.div(intermediate3);
        int128 sqrtPriceA = intermediate2.add(sqrtPrice).sub(intermediate4);
        return sqrtPriceA.pow(2).toUInt();
    } 

    /// @dev calculate price upper boundary skip liquidity
    function calculatepriceB2(uint256 price, uint256 priceA, uint256 amountX, uint256 amountY) internal pure returns(uint256) {
        int128 priceFixed = ABDKMath64x64.fromUInt(price);
        int128 sqrtPrice = ABDKMath64x64.fromUInt(price).sqrt();
        int128 sqrtPriceA = ABDKMath64x64.fromUInt(priceA).sqrt();
        int128 amountXFixed = ABDKMath64x64.fromUInt(amountX);
        int128 amountYFixed = ABDKMath64x64.fromUInt(amountY);
        int128 intermediate1 = sqrtPriceA.mul(sqrtPrice).sub(priceFixed).mul(amountXFixed).add(amountYFixed);
        return sqrtPrice.mul(amountYFixed).div(intermediate1).pow(2).toUInt();
    }

    /// @dev price change after by X swap https://www.youtube.com/watch?v=wKMayX0SoUE
    function calculatePNewForX(uint256 price, uint256 liqidity, uint256 deltaX) internal pure returns(uint256) {
        int128 sqrtPrice = ABDKMath64x64.fromUInt(price).sqrt();
        int128 liquidityFixed = ABDKMath64x64.fromUInt(liqidity);
        int128 deltaXFixed = ABDKMath64x64.fromUInt(deltaX);
        int128 intermediate = deltaXFixed.mul(sqrtPrice).add(liquidityFixed);
        return liquidityFixed.mul(sqrtPrice).div(intermediate).pow(2).toUInt();
    }

    /// @dev price change after by Y swap https://www.youtube.com/watch?v=wKMayX0SoUE
    function calculatePNewForY(uint256 price, uint256 liqidity, uint256 deltaY) internal pure returns(uint256) {
        int128 sqrtPrice = ABDKMath64x64.fromUInt(price).sqrt();
        int128 liquidityFixed = ABDKMath64x64.fromUInt(liqidity);
        int128 deltaYFixed = ABDKMath64x64.fromUInt(deltaY);
        return deltaYFixed.div(liquidityFixed).add(sqrtPrice).pow(2).toUInt();
    }



    function _getprice(
        uint256 price,
        uint256 priceA,
        uint256 priceB
    ) private pure returns (uint256 tempP) {
        if (price >= priceB) {
            tempP = priceB;
        } else {
            tempP = price;
        }

        if (tempP > priceA) {
            tempP = tempP;
        } else {
            tempP = priceA;
        }
    }
}
