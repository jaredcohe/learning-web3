// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// https://eips.ethereum.org/EIPS/eip-721
// https://docs.openzeppelin.com/contracts/4.x/api/token/erc721#IERC721-approve-address-uint256-
// Import libraries
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0-beta.0/contracts/token/ERC721/ERC721Full.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Metadata.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721Full.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

//import "hardhat/console.sol";
import {Base64} from "https://github.com/jaredcohe/learning-web3/blob/main/Base64.sol";

// ERC721URIStorage, IERC721Enumerable, , IERC721, IERC721Metadata, ERC721Full
contract myNftMachine is ERC721URIStorage, IERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    address owner;
    string title;
    string description;
    string image;
    string providerName;
    string providerUrl;
    string startYear;
    string endYear;
    string notes;

    constructor() ERC721("Token Title", "SYM") {
        //console.log("Constructor function running");
        owner = msg.sender;
        //console.log("Address of contract owner: ", owner);
    }

    function mintMyNft(
        string memory _title,
        string memory _description,
        string memory _image,
        string memory _providerName,
        string memory _providerUrl,
        string memory _startYear,
        string memory _endYear,
        string memory _notes
    ) public {

        title = _title;
        description = _description;
        image = _image;
        providerName = _providerName;
        providerUrl = _providerUrl;
        startYear = _startYear;
        endYear = _endYear;
        notes = _notes;
        
        require(bytes(title).length > 0, "Need a Title");
        require(bytes(description).length > 0, "Need a Description");
        require(msg.sender == owner, "Only Owner can call function");

        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        // Mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        // Create tokenURI from JSON and base64 encode it
        string memory json = string(
            abi.encodePacked(
                '{"name": "',
                title,
                '", "description":"',
                description,
                '", "image": "',
                image,
                '", "attributes": {"providerName": "', 
                                    providerName, 
                                    '", "providerUrl": "', 
                                    providerUrl,
                                    '", "startYear": "', 
                                    startYear,
                                    '", "endYear": "', 
                                    endYear,
                                    '", "notes": "', 
                                    notes,
                '"}}'
            )
        );

        //console.log("tokenURI json: ", json);

        string memory jsonBase64Encoded = Base64.encode(bytes(json));

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", jsonBase64Encoded)
        );

        //console.log("tokenURI base64: ", finalTokenUri);

        // Set the NFTs data
        _setTokenURI(newItemId, finalTokenUri);

        //console.log(
        //    "An NFT with ID %s has been minted to %s",
        //    newItemId,
        //    msg.sender
        //);

        // Increment the counter for when the next NFT is minted
        _tokenIds.increment();
    }

    // Hook that runs before any transfer
    // Another way to prevent transfer of tokens
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
        //console.log(from);
        //console.log(to);
        //console.log(msg.sender);
        //console.log(owner);
        //console.log(tokenId);
        require(msg.sender == owner, "Only Owner of contract can transfer its own tokens, no other transfers");
    }
    
    function totalSupply() external view returns (uint256) {
        
    }

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address _owner, uint256 index) external view returns (uint256 tokenId) {
        
    }

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256) {
        
    }
}
