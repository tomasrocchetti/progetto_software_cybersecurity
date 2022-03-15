// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.0 <0.9.0;

contract Transactions {

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
function addProduct(string _name, string _ID,  uint _gCO2, uint _isProcessed, string _productsUsedToProcessID, uint _quantityForUsedProducts, uint _quantity) {
       var prod = Products[_ID];    // deprecata, non funziona piu sulle versioni nuove di solidity =(
       prod.name = _name;
       prod.ID = _ID;
       prod.gCO2=_gCO2;
       prod.isProcessed = _isProcessed;
       prod. productsUsedToProcessIDs = _productsUsedToProcessID;
       prod.quantityForUsedProducts = _quantityForUsedProducts;
       prod.quantityForUsedProducts = _quantity;
       productIDs.push(_ID) -1;
    }
    
    
function getProductByID(string _ID) view public returns (string, string, uint, uint, string, uint, uint){
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
