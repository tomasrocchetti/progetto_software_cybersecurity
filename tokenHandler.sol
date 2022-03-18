// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.2;

import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";
 

contract mNFT is NFTokenMetadata, Ownable {
 
    constructor() {
      nftName = "Carbon Footprint";
      nftSymbol = "CBF";
    }

    function mint(address _to, uint256 _tokenId, string calldata _uri) external onlyOwner {
      super._mint(_to, _tokenId);
      super._setTokenUri(_tokenId, _uri);
    }
  
      function burn( uint256 _tokenId) public {
        super._burn(_tokenId);
    }
 
}
