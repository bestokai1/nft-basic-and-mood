// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {BasicNFT} from "../src/BasicNFT.sol";
import {DeployBasicNFT} from "./DeployBasicNFT.s.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";



contract MintBasicNFT is Script {
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external{
        address mostRecentDeploy = DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
        mintNFTOnContract(mostRecentDeploy);
    }

    function mintNFTOnContract(address contractAddress) public{
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNFT(PUG);
        vm.stopBroadcast();
    }
    
}