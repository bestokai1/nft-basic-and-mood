// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";


/**
 * @title BasicNFT Smart Contract
 * @author Tshediso Nicholas Matsasa
 * @notice This smart contract is a basic NFT with a mint function. each NFT minted gets a tokenURI assigned.
 * @dev This contract uses OpenZeppelin's ERC721 implementation
 */
contract BasicNFT is ERC721{
    uint256 private s_tokenCounter;

    mapping (uint256 => string) private s_tokenIdToUri;

    /// @notice Constructor to initialize the NFT contract with a name and symbol
    /// @dev Sets the initial token counter to 0
    constructor() ERC721("Dogie", "DOG"){
        s_tokenCounter = 0;
    }

    /// @notice Mints a new NFT with the specified URI
    /// @param tokenUri The URI of the token metadata
    /// @dev Stores the URI in a mapping and mints the token to the caller's address
    function mintNFT(string memory tokenUri) public{
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }
    
    /// @notice Returns the URI of the specified token ID
    /// @param tokenID The ID of the token
    /// @return The URI of the token metadata
    /// @dev Overrides the base tokenURI function to return the stored URI
    function tokenURI(uint256 tokenID) public view override returns(string memory){
        return s_tokenIdToUri[tokenID];
    }
}