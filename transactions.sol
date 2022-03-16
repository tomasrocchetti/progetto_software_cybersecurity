// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract Transactions {

// indirizzi per trasformatore, cliente e produttore
address produttore;
address trasformatore;
address cliente;

struct Product {
    string name;    // nome del prodotto
    string ID;  // identificativo univoco del prodotto (anche numero di lotto)
    uint gCO2;  // grammi di CO2 usati per produrre o per fare la trasformazione
    uint isProcessed;   // 0 se è una materia prima, 1 se è un derivato
    string productsUsedToProcessIDs;    // se è un derivato elencare tutti gli ID delle materie prime usate, deve essere un array
    uint quantityForUsedProducts;   // per ogni ID di materia prima indicare la quantità utilizzata, anche questo deve essere un array
    uint quantity;  //quantità di prodotto, utile anche nel caso in cui per un prodotto finale venga usata solo una parte di un lotto di materia prima
    }

// mapping della lista di prodotti
mapping (string => Product) Products;

string[] public productIDs;

// funzione per aggiungere una nuova transazione (ovvero una nuova materia prima o un nuovo prodotto frutto di lavorazione)
function addProduct(string memory _name, string calldata _ID,  uint _gCO2, uint _isProcessed, string memory _productsUsedToProcessID, uint _quantityForUsedProducts, uint _quantity) public {
       
       // si assicura che siano soltanto produttore e trasformatore ad aggiungere nuovi prodotti o materie prime, il cliente non può
       if(msg.sender == produttore || msg.sender == trasformatore){
        Product storage prod = Products[_ID];
        prod.name = _name;
        prod.ID = _ID;
        prod.gCO2=_gCO2;
        prod.isProcessed = _isProcessed;
        prod. productsUsedToProcessIDs = _productsUsedToProcessID;
        prod.quantityForUsedProducts = _quantityForUsedProducts;
        prod.quantityForUsedProducts = _quantity;

        productIDs.push(_ID);
       }
    }
    
    
function getProductByID(string memory _ID) view public returns (string memory, string memory, uint, uint, string memory, uint, uint){
    return (Products[_ID].name,
    Products[_ID].ID,
    Products[_ID].gCO2,
    Products[_ID].isProcessed,
    Products[_ID].productsUsedToProcessIDs,
    Products[_ID].quantityForUsedProducts,
    Products[_ID].quantity);
    }
    
}  

/*
- productsUsedToProcessIDs deve essere un array
- quantityForUsedProducts deve essere un array
*/
