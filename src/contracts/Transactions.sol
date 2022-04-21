// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract Transactions is ERC721{



// indirizzi per trasformatore, cliente e produttore
address produttore = 0x513Cd7f2bBBB9C125534Ad79B1a641cD0192a445;
address trasformatore;
address cliente;

struct Product {
    string name;    // nome del prodotto
    uint ID;  // identificativo univoco del prodotto (anche numero di lotto)
    uint gCO2;  // grammi di CO2 usati per produrre o per fare la trasformazione
    bool isProcessed;   // 0 se è una materia prima, 1 se è un derivato
    uint[] productsUsedToProcessIDs;    // se è un derivato elencare tutti gli ID delle materie prime usate, deve essere un array
    uint quantity;  //quantità di prodotto, utile anche nel caso in cui per un prodotto finale venga usata solo una parte di un lotto di materia prima
    }

// mapping della lista di prodotti
mapping (uint => Product) Products;

uint[] public productIDs;

event newMateriaPrima (string name, uint ID, uint gCO2, uint quantity);
event newProdottoTrasformato (string name, uint ID, uint sommaCO2, uint[] productsUsedToProcessID, uint quantity);

constructor () public ERC721 ("carbonfootprint", "CBF"){}
 
 
// funzione per aggiungere una nuova transazione (ovvero una nuova materia prima o un nuovo prodotto frutto di lavorazione)
function addMateriaPrima(string memory _name, uint _ID,  uint _gCO2, uint _quantity) public {
       
       // si assicura che sia soltanto il produttore ad aggiungere nuovi materie prime
       require(msg.sender == produttore);
       require(!idExist(_ID));
       
      // if(msg.sender == produttore && !idExist(_ID))
        Product storage prod = Products[_ID];
        prod.name = _name;
        prod.ID = _ID;
        prod.gCO2=_gCO2;
        prod.quantity = _quantity;
        prod.isProcessed = false;

        productIDs.push(_ID);
       
        emit newMateriaPrima(_name, _ID, _gCO2, _quantity);
        _mint(msg.sender, _ID);

    }

// funzione per aggiungere una nuova transazione (ovvero una nuova materia prima o un nuovo prodotto frutto di lavorazione)
function addProdottoTrasformato(string memory _name, uint _ID,  uint _gCO2_production, uint[] memory _productsUsedToProcessID, uint _quantity) public {
       
       // si assicura che sia soltanto il trasformatore ad aggiungere nuovi prodotti 
       // if(msg.sender == trasformatore && !idExist(_ID))
       require(msg.sender == trasformatore);
       require(!idExist(_ID));
       
        Product storage prod = Products[_ID];
        prod.name = _name;
        prod.ID = _ID;
            
        uint sommaCO2 = 0;
        for (uint i = 0; i< _productsUsedToProcessID.length; i++){
            require(ownerOf(_productsUsedToProcessID[i]) == msg.sender);
            _burn(_productsUsedToProcessID[i]);
            sommaCO2 = sommaCO2 + (getCO2ByID(_productsUsedToProcessID[i]));
        }
        sommaCO2 = sommaCO2 +_gCO2_production;
        
        prod.gCO2=sommaCO2;
        prod.isProcessed = true;
        prod.productsUsedToProcessIDs = _productsUsedToProcessID;
        prod.quantity = _quantity;

        productIDs.push(_ID);
       
        emit newProdottoTrasformato(_name, _ID, sommaCO2, _productsUsedToProcessID, _quantity);
        _mint(msg.sender, _ID);
      
    }
    
function getOwner(uint tokenId) view public returns (address){
    if(_exists(tokenId)){
        return ownerOf(tokenId);
        }else{
            return 0x0000000000000000000000000000000000000000;
        }
    }
    
function transferToken(address toAddress, uint tokenId) public{
    _transfer(msg.sender, toAddress, tokenId);
    }    
    
    
function getProductByID(uint _ID) view public returns (string memory, uint, uint, bool, uint[] memory, uint){
    return (Products[_ID].name, Products[_ID].ID, Products[_ID].gCO2, Products[_ID].isProcessed, Products[_ID].productsUsedToProcessIDs, Products[_ID].quantity);
    }
    
function getCO2ByID(uint _ID) view public returns (uint){
    return Products[_ID].gCO2;
    }
    
function getLen() view public returns (uint){
    return productIDs.length;
    }
    
function getNameByID(uint _ID) view public returns (string memory){
    return Products[_ID].name;
    }
    
function getQtyByID(uint _ID) view public returns (uint){
    return Products[_ID].quantity;
    }
    
    
function idExist(uint _ID) view public returns (bool){
     bool exist = true;
     if(Products[_ID].ID == 0){
         exist = false;
     } else{
         exist = true;
     }
     return (exist);
    }

function listItems() view public returns (string memory){
        string memory ret;
        for (uint i = 0; i < productIDs.length; i++) {
            ret = string( abi.encodePacked(ret, "\n", productIDs[i], " - ", Strings.toString(getCO2ByID(productIDs[i]))));
        }
        return ret;
    }
    
}  

// da fare parsing di productsUsedToProcessIDs, CSV
