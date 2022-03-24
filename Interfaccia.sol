// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


interface interfacciaFornitore {

    //funzione che restituisce le materie prime del fornitore
    function getMateriaById(string memory _ID) view public returns (string memory, string memory, uint, bool, string memory, uint, uint);

    //funzione per inserire materie prime, lo puo fare solamente il fornitore
    function addMateriaPrima(string memory _name, string calldata _ID,  uint _gCO2, uint _quantity) private;

}

interface interfacciaTransazione{

    //funzione che restituisce le materie prime del fornitore (se la usa il produttore)
    // e le materie finite del Produttore (se la usa il cliente)
    function getDisponibility () public view returns (string  _disponibility );

    //funzione per inserire le materie finite, lo puo fare solamente il produttore
    function setProdotto(struct prodotto) private ;

    //funzione che passa l'elemento da un address ad un altro
    function compraMateria();

}
