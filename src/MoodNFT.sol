//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @title Mood NFT Smart Contract
 * @author Tshediso Nicholas Matsasa
 * @notice This contract allows users to mint NFTs that reflect their mood (HAPPY or SAD)
 * @dev This contract uses OpenZeppelin's ERC721 implementation
 */
contract MoodNFT is ERC721 {
    error MoodNFT__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_happySVGImgURI;
    string private s_sadSVGImgURI;

    enum Mood{HAPPY, SAD}

    mapping (uint256 => Mood) private s_tokenIDToMood;

    /// @notice Constructor to initialize the NFT contract with happy and sad SVG image URIs
    /// @param happySVGImgURI The URI of the happy SVG image
    /// @param sadSVGImgURI The URI of the sad SVG image
    constructor(string memory happySVGImgURI, string memory sadSVGImgURI) ERC721("Mood NFT", "MNFT"){
        s_tokenCounter = 0;
        s_happySVGImgURI = happySVGImgURI;
        s_sadSVGImgURI = sadSVGImgURI;
    }

    /// @notice Mints a new NFT with an initial mood of HAPPY
    /// @dev Stores the initial mood in a mapping and mints the token to the caller's address
    function mintNFT() public{
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIDToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    /// @notice Flips the mood of the specified tokenID
    /// @param tokenID The ID of the token whose mood is to be flipped
    /// @dev Reverts if the caller is not the owner of the token
    function flipMood(uint256 tokenID) public view{
        if (!_isAuthorized(msg.sender, msg.sender, tokenID)) {
            revert MoodNFT__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIDToMood[tokenID] == Mood.HAPPY) {
            s_tokenIDToMood[tokenID] == Mood.SAD;
        } else {
            s_tokenIDToMood[tokenID] == Mood.HAPPY;
        }
    }

    /// @notice Returns the base URI for the token metadata
    /// @dev Overrides the base URI function to return a data URI scheme
    function _baseURI() internal pure override returns(string memory){
        return "data:application/json;base64,";
    }

    /// @notice Returns the URI of the specified tokenID
    /// @param tokenID The ID of the token
    /// @return The URI of the token metadata
    /// @dev Encodes the metadata in a base64 data URI scheme
    function tokenURI(uint256 tokenID) public view override returns(string memory){
        string memory imgURI;

        if (s_tokenIDToMood[tokenID] == Mood.HAPPY) {
            imgURI = s_happySVGImgURI;
        }else {
            imgURI = s_sadSVGImgURI;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(bytes(abi.encodePacked('{"name": "', name(), '", "description": "An NFT that reflects the mood of the owner.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "', imgURI, '"}')))
            )
        );
    }
}