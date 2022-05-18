pragma solidity >=0.8.0 <0.9.0;


interface interfaceTransactions {

    function addMateriaPrima(string memory _name, uint _ID,  uint _gCO2, uint _quantity) external;

    function addProdottoTrasformato(string memory _name, uint _ID,  uint _gCO2_production, uint[] memory _productsUsedToProcessID, uint _quantity) external;

    function getOwner(uint tokenId) external view returns (address);

    function transferToken(address toAddress, uint tokenId) external;

    function getCO2ByID(uint _ID) external view returns (uint);

    function getLen() external view returns (uint);

    function getNameByID(uint _ID) external view returns (string memory);

    function getUsedProductForTransform(uint _ID) external view returns (uint[] memory);

    function getQtyByID(uint _ID) external view returns (uint);

    function idExist(uint _ID) external view returns (bool);

    function setAddresses(address customProduttore, address customTrasformatore) external;

}
