// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DanaiSaya} from "../src/DanaiSaya.sol";

contract DanaiSayaTest is Test {
    // test
    DanaiSaya danaiSaya;
    // code

    function setUp() external {
        // code
        danaiSaya = new DanaiSaya();
    }

    function testMinimumDollarIsFive() public view {
        // code
        assertEq(danaiSaya.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwnerIsMsgSender() public view {
        // code
        assertEq(danaiSaya.i_pemilik(), address(this));
    }
}
