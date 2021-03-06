// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract Transactions is ERC721 {

/**************************************************************************************************
indirizzi relativi agli attori, potranno essere settati a piacimento
**************************************************************************************************/
address fornitore;
address produttore;
address cliente;


/**************************************************************************************************
struttura che definisce il tipo Product, ovvero il prodotto e tutti i suoi attributi
**************************************************************************************************/
struct Product {
    string name;    // nome del prodotto
    uint ID;  // identificativo univoco del prodotto (similmente al numero di lotto)
    uint gCO2;  // grammi di CO2 usati per produrre una materia prima o per la lavorazione di un prodotto
    bool isProcessed;   // 0 se è una materia prima, 1 se è un prodotto derivato
    uint[] productsUsedToProcessIDs;    // se si tratta di un prodotto derivato elencare tutti gli ID delle materie prime usate. [N.B. E' un array]
    uint quantity;  //quantità di prodotto, utile anche nel caso in cui per un prodotto lavorato venga usata solo una parte di un lotto di materia prima
    }


/**************************************************************************************************
mapping della lista prodotti e generazione dell'array contenente l'ID di ogni prodotto
grazie al mapping è facile trovare un prodotto in base al proprio ID
**************************************************************************************************/
mapping (uint => Product) Products;
uint[] public productIDs;


/**************************************************************************************************
definizione degli eventi 
**************************************************************************************************/
event newMateriaPrima (string name, uint ID, uint gCO2, uint quantity);
event newProdottoLavorato (string name, uint ID, uint sommaCO2, uint[] productsUsedToProcessID, uint quantity);


/**************************************************************************************************
nel costruttore vengono definiti il nome e il simbolo dei token
**************************************************************************************************/
constructor () ERC721 ("carbonfootprint", "CBF"){}
 
 
/**************************************************************************************************
funzione per aggiungere un nuovo prodotto (materia prima), chiede in ingresso tutti gli attributi
necessari alla definizione di una nuova materia prima, richiede che l'indirizzo di chi invoca la 
funzione sia l'indirizzo di un fornitore, inoltre richiede che l'ID che si è inserito per la nuova 
materia prima non sia gia stato usato.
Viene anche generato un token associato al prodotto inserito
**************************************************************************************************/
function addMateriaPrima(string memory _name, uint _ID,  uint _gCO2, uint _quantity) public {
       
       // si assicura che sia soltanto il fornitore ad aggiungere nuove materie prime
       require(msg.sender == fornitore);
       require(!idExist(_ID));
       
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


/**************************************************************************************************
funzione per aggiungere un nuovo prodotto (prodotto lavorato), chiede in ingresso tutti gli 
attributi necessari alla definizione di una nuovo prodotto, quindi anche le materie prime o altri 
prodotti usati per la lavorazione.
Richiede che l'indirizzo di chi invoca la funzione sia l'indirizzo di un produttore, 
inoltre richiede che l'ID che si è inserito per il nuovo prodotto
non sia gia stato usato.
vengono sommati i valori del carbon footprint dei prodotti usati per la lavorazione.
Viene generato un token associato al prodotto inserito e vengono bruciati i token dei
prodotti usati nella lavorazione, per questo motivo è necessario che i token dei prodotti usati 
per la lavorazione siano di proprietà dell'indirizzo che invoca la funzione
Sarebbe possibile accorpare addProdottoLavorato con addMateriaPrima, nonostante ciò è stato 
deciso di separare completamente le due funzioni per dare maggiore madularità al programma, e per 
modificarlo in futuro
**************************************************************************************************/
function addProdottoLavorato(string memory _name, uint _ID,  uint _gCO2_production, uint[] memory _productsUsedToProcessID, uint _quantity) public {
       
       // si assicura che sia soltanto il produttore ad aggiungere nuovi prodotti 
       require(msg.sender == produttore);
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
       
        emit newProdottoLavorato(_name, _ID, sommaCO2, _productsUsedToProcessID, _quantity);
        _mint(msg.sender, _ID);
    }
    
    
/**************************************************************************************************
restituisce l'indirizzo del proprietario di un token, se il token non esiste restituisce un 
indirizzo formato da zeri
**************************************************************************************************/ 
function getOwner(uint tokenId) view public returns (address){
    if(_exists(tokenId)){
        return ownerOf(tokenId);
        }else{
            return 0x0000000000000000000000000000000000000000;
        }
    }


/**************************************************************************************************
trasferisce un token da un indirizzo ad un altro
**************************************************************************************************/ 
function transferToken(address toAddress, uint tokenId) public{
    _transfer(msg.sender, toAddress, tokenId);
    }    


/**************************************************************************************************
restituisce il valore di carbon footprint dato l'ID di un prodotto
**************************************************************************************************/ 
function getCO2ByID(uint _ID) view public returns (uint){
    return Products[_ID].gCO2;
    }
   
   
/**************************************************************************************************
restituisce il numero di prodotti presenti in catalogo
**************************************************************************************************/ 
function getLen() view public returns (uint){
    return productIDs.length;
    }


/**************************************************************************************************
restituisce il nome di un prodotto dato il suo ID
**************************************************************************************************/ 
function getNameByID(uint _ID) view public returns (string memory){
    return Products[_ID].name;
    }
   
   
/**************************************************************************************************
restituisce l'array contenente la lista dei prodotti utilizzati per la lavorazione
**************************************************************************************************/    
function getUsedProductForTransform(uint _ID) view public returns (uint[] memory){
    return Products[_ID].productsUsedToProcessIDs;
}


/**************************************************************************************************
restituisce la quantità di un prodotto dato il suo ID
**************************************************************************************************/ 
function getQtyByID(uint _ID) view public returns (uint){
    return Products[_ID].quantity;
    }
   
   
/**************************************************************************************************
controlla se un ID esiste oppure no
**************************************************************************************************/     
function idExist(uint _ID) view public returns (bool){
     bool exist = true;
     if(Products[_ID].ID == 0){
         exist = false;
     } else{
         exist = true;
     }
     return (exist);
    }


/**************************************************************************************************
serve per configurare gli indirizzi che hanno il permesso di eseguire operazioni da fornitore
e quelli che hanno il permesso di eseguire operazioni da produttore
**************************************************************************************************/ 
function setAddresses(address customFornitore, address customProduttore) public{
    fornitore = customFornitore;
    produttore = customProduttore;
    }
    
}  
