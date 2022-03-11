// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Transactions {

struct Product {
    string name;    // nome del prodotto
    string ID;  // identificativo univoco del prodotto (anche numero di lotto)
    uint gCO2;  // grammi di CO2 usati per produrre o per fare la trasformazione
    uint isProcessed;   // 0 se è una materia prima, 1 se è un derivato
    string productsUsedToProcessIDs;    // se è un derivato elencare tutti gli ID delle materie prime usate, deve essere un array
    uint quantityForUsedProducts;   // per ogni ID di materia prima indicare la quantità utilizzata, anche questo deve essere un array
    uint quantity;
}



Product[] public products;

// funzione per aggiungere una nuova transazione (ovvero una nuova materia prima o un nuovo prodotto frutto di lavorazione)
function addProduct(string _name, string _ID,  uint _gCO2, uint _isProcessed, string _productsUsedToProcessID, uint _quantityForUsedProducts, uint _quantity) {
        products.push(Product(_name, _ID, _gCO2, _isProcessed, _productsUsedToProcessID, _quantityForUsedProducts, _quantity));
    }
}    
