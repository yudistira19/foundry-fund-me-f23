// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DanaiSaya} from "../src/DanaiSaya.sol";

contract DeployDanaiSaya is Script {
    // code
    function run() external {
        vm.startBroadcast();
        new DanaiSaya();
        vm.stopBroadcast();
        // code
    }
}
