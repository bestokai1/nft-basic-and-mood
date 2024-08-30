// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {MoodNFT} from "../src/MoodNFT.sol";
import {Script, console} from "forge-std/Script.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNFT is Script{
    function run() external returns (MoodNFT) {
        string memory sadSVG = vm.readFile("./img/Sad.svg");
        string memory happySVG = vm.readFile("./img/Happy.svg");
        console.log(sadSVG);

        vm.startBroadcast();
        MoodNFT moodNFT = new MoodNFT(svgToImgURI(happySVG), svgToImgURI(sadSVG));
        vm.stopBroadcast();
        return moodNFT;
    }

    function svgToImgURI(string memory svg) public pure returns(string memory){
        string memory baseURI = "data:image/svg+xml;base64,";
        // string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        string memory svgBase64Encoded = Base64.encode(bytes(svg));
        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}