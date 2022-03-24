// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./strings.sol";
import "./Interfaccia.sol"

contract Fornitore is interfacciaFornitore {

using strings for *;

// indirizzi per trasformatore, cliente e produttore
address produttore;

struct Product {
    string name;    // nome del prodotto
    string ID;  // identificativo univoco del prodotto (anche numero di lotto)
    uint gCO2;  // grammi di CO2 usati per produrre o per fare la trasformazione
    bool isProcessed;   // 0 se è una materia prima, 1 se è un derivato
    string productsUsedToProcessIDs;    // se è un derivato elencare tutti gli ID delle materie prime usate, deve essere un array
    uint quantityForUsedProducts;   // per ogni ID di materia prima indicare la quantità utilizzata, anche questo deve essere un array
    uint quantity;  //quantità di prodotto, utile anche nel caso in cui per un prodotto finale venga usata solo una parte di un lotto di materia prima
    }

// mapping della lista di prodotti
mapping (string => Product) Products public;

string[] public productIDs public;

constructor(address produttore_) {
        produttore = produttore_;
    }
 
// funzione per aggiungere una nuova transazione (ovvero una nuova materia prima o un nuovo prodotto frutto di lavorazione)
function addMateriaPrima(string memory _name, string calldata _ID,  uint _gCO2, uint _quantity) public {
       
       // si assicura che siano soltanto produttore e trasformatore ad aggiungere nuovi prodotti o materie prime, il cliente non può
       if(!idExist(_ID)){
        Product storage prod = Products[_ID];
        prod.name = _name;
        prod.ID = _ID;
        prod.gCO2=_gCO2;
        prod.isProcessed = false;
        prod.quantityForUsedProducts = _quantity;

        productIDs.push(_ID);
       }
       else{
        // errore, non puoi completare l'operazione
       }
    }

    
function getMateriaById(string memory _ID) view public returns (string memory, string memory, uint, bool, string memory, uint, uint){
    return (Products[_ID].name, Products[_ID].ID, Products[_ID].gCO2, Products[_ID].isProcessed, Products[_ID].productsUsedToProcessIDs, Products[_ID].quantityForUsedProducts, Products[_ID].quantity);
    }
    
function getCO2ByID(string memory _ID) view public returns (uint){
    return Products[_ID].gCO2;
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

