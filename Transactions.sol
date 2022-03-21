
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/utils/Strings.sol";

contract Transactions {

// indirizzi per trasformatore, cliente e produttore
address fornitore;
address produttore;
address cliente;

struct  MateriaPrima{
    string lotto;
    string nome;
    uint256 quantita;
    uint256 footPrint;
}

struct Prodotto{
    string lottoProd;
    string[] lottiMateriePrime;
    string nome;
    uint256 unita;
    uint[] productFootPrints;
}

Prodotto[] public lista_prodotti;

uint256 lengthMateriePrime;
uint256 lenghtProdotti;

mapping(string => bool) public MateriaPrimaExists;

mapping(string => MateriaPrima) public lista_materiaprima;

constructor(address fornitore_, address produttore_, address cliente_) {
        fornitore = fornitore_;
        produttore = produttore_;
        cliente = cliente_;
        lengthMateriePrime = 0;
        lenghtProdotti = 0;
    }

function aggiuntaMateriaPrima(string memory _lotto, string memory _nome, uint _quantita, uint _footPrint) public {
    //require(msg.sender == fornitore);

       //string memory lotto = string(abi.encodePacked(_lotto));
       
       require(!MateriaPrimaExists[_lotto]);

        lista_materiaprima[_lotto] = MateriaPrima({
            lotto : _lotto,
            nome : _nome,
            quantita : _quantita,
            footPrint : _footPrint
            });

        MateriaPrimaExists[_lotto] = true;
       // lengthMateriePrime++;
        }
function searchMateriaPrimaByLotto(string memory _lotto) public view returns(string memory){
        return Strings.toString(lista_materiaprima[_lotto].footPrint);
    }  


}
    
    
