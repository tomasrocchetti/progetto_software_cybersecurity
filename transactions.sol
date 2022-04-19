// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Transactions is ERC271 {



// indirizzi per trasformatore, cliente e produttore
address produttore;
address trasformatore;
address cliente;

struct Product {
    string name;    // nome del prodotto
    string ID;  // identificativo univoco del prodotto (anche numero di lotto)
    uint gCO2;  // grammi di CO2 usati per produrre o per fare la trasformazione
    bool isProcessed;   // 0 se è una materia prima, 1 se è un derivato
    string[] productsUsedToProcessIDs;    // se è un derivato elencare tutti gli ID delle materie prime usate, deve essere un array
    uint[] quantityForUsedProducts;   // per ogni ID di materia prima indicare la quantità utilizzata, anche questo deve essere un array
    uint quantity;  //quantità di prodotto, utile anche nel caso in cui per un prodotto finale venga usata solo una parte di un lotto di materia prima
    }

// mapping della lista di prodotti
mapping (string => Product) Products;

string[] public productIDs;

event newMateriaPrima (string name, string ID, uint gCO2, uint quantity);
event newProdottoTrasformato (string name, string ID, uint sommaCO2, string[] productsUsedToProcessID, uint[] quantityForUsedProducts, uint quantity);
event returnCO2 (uint gCO2);

constructor(address produttore_, address trasformatore_, address cliente_) {
        produttore = produttore_;
        trasformatore = trasformatore_;
        cliente = cliente_;
    }
 
// funzione per aggiungere una nuova transazione (ovvero una nuova materia prima o un nuovo prodotto frutto di lavorazione)
function addMateriaPrima(string memory _name, string calldata _ID,  uint _gCO2, uint _quantity) public {
       
       // si assicura che sia soltanto il produttore ad aggiungere nuovi materie prime
       require(msg.sender == produttore);
       require(!idExist(_ID));
       
      // if(msg.sender == produttore && !idExist(_ID))
        Product storage prod = Products[_ID];
        prod.name = _name;
        prod.ID = _ID;
        prod.gCO2=_gCO2;
        prod.isProcessed = false;

        productIDs.push(_ID);
       
        emit newMateriaPrima(_name, _ID, _gCO2, _quantity);

    }

// funzione per aggiungere una nuova transazione (ovvero una nuova materia prima o un nuovo prodotto frutto di lavorazione)
function addProdottoTrasformato(string memory _name, string calldata _ID,  uint _gCO2_production, string[] memory _productsUsedToProcessID, uint[] memory _quantityForUsedProducts, uint _quantity) public {
       
       // si assicura che sia soltanto il trasformatore ad aggiungere nuovi prodotti 
       // if(msg.sender == trasformatore && !idExist(_ID))
       require(msg.sender == trasformatore);
       require(!idExist(_ID));
       
        Product storage prod = Products[_ID];
        prod.name = _name;
        prod.ID = _ID;
            
        uint sommaCO2 = 0;
        for (uint i = 0; i< _productsUsedToProcessID.length; i++){
            sommaCO2 = sommaCO2 + (getCO2ByID(_productsUsedToProcessID[i])*_quantityForUsedProducts[i]);
        }
        sommaCO2 = sommaCO2 +_gCO2_production;
        
        prod.gCO2=sommaCO2;
        prod.isProcessed = true;
        prod.productsUsedToProcessIDs = _productsUsedToProcessID;
        prod.quantityForUsedProducts = _quantityForUsedProducts;
        prod.quantity = _quantity;

        productIDs.push(_ID);
       
        emit newProdottoTrasformato(_name, _ID, sommaCO2, _productsUsedToProcessID, _quantityForUsedProducts, _quantity);

      
    }
    
    
function getProductByID(string memory _ID) view public returns (string memory, string memory, uint, bool, string[] memory, uint[] memory, uint){
    return (Products[_ID].name, Products[_ID].ID, Products[_ID].gCO2, Products[_ID].isProcessed, Products[_ID].productsUsedToProcessIDs, Products[_ID].quantityForUsedProducts, Products[_ID].quantity);
    }
    
function getCO2ByID(string memory _ID) view public returns (uint){
    return Products[_ID].gCO2;
    }
    
function getCO2ByIDEvent(string memory _ID)  public{
    emit returnCO2(Products[_ID].gCO2);
    }
    
function idExist(string memory _ID) view public returns (bool){
     bool exist = true;
     if(keccak256(abi.encodePacked(Products[_ID].ID)) == keccak256(abi.encodePacked(""))){
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
