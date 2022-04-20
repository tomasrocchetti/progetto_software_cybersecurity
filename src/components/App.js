import React, { Component } from 'react';
import Web3 from 'web3'
import logo from '../logo.png';
import './App.css';
import Transactions from '../abis/Transactions.json'
import Navbar from './Navbar'

class App extends Component {

    state = {
        listOfProducts: [],
    };
  


    async componentWillMount() {
        await this.loadWeb3()
        await this.loadBlockchainData()
    }

    async loadWeb3() {
        if (window.ethereum) {
            window.web3 = new Web3(window.ethereum)
            await window.ethereum.enable()
        }
        else if (window.web3) {
            window.web3 = new Web3(window.web3.currentProvider)
        }
        else {
            window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3
        // load account
        const accounts = await web3.eth.getAccounts()
        this.setState({ account: accounts[0] })
        const networkId = await web3.eth.net.getId()
        const networkData = Transactions.networks[networkId]
        if(networkData) {
            const marketplace = web3.eth.Contract(Transactions.abi, networkData.address)
            const len = await marketplace.methods.getLen().call()
            window.alert("numero prodotti: " +len)
            const prd = {name: "", id: "", gco2: 0, quantity: 0 };
            for(var i=0; i<len;i++){
                const mproductID = await marketplace.methods.productIDs(i).call();
                const mgCO2 = await marketplace.methods.getCO2ByID(mproductID.toString()).call();
                const mprodQty = await marketplace.methods.getQtyByID(mproductID.toString()).call();
                const mprodName = await marketplace.methods.getNameByID(mproductID.toString()).call();
                const prd ={name:mprodName, id: mproductID, gco2: mgCO2, quantity: mprodQty };
                this.state.listOfProducts[i] = prd
            }
        this.setState({ marketplace })
        } else {
            window.alert('Marketplace contract not deployed to detected network.')
        }
    }

    addMateriaPrima(name, id, gco2, quantity) {
        this.state.marketplace.methods.addMateriaPrima(name, id, gco2, quantity).send({ from: this.state.account }).once('receipt', (receipt) => { })
    }
  
    addProdottoTrasformato(name, id, gco2, usedProd, usedQty, quantity) {
        this.state.marketplace.methods.addProdottoTrasformato(name, id, gco2, usedProd, usedQty, quantity).send({ from: this.state.account }).once('receipt', (receipt) => {})
    }

    async getCO2ByID(id){
        const gCO2 =  await this.state.marketplace.methods.getCO2ByID(id.toString()).call();
        if(gCO2 == 0){
            window.alert('Il prodotto con ID "' + id + '" non esiste');
        } else{
            window.alert('Il prodotto con ID "' + id + '" ha un carbon footprint di ' + gCO2 + 'g di CO2');
        }
    }
  
   

    

  


    render() {
        return (
        
       
            <div id="content">
            <h1>Aggiungi un Prodotto</h1>
            <h9>{this.state.account}</h9>
            <hr></hr>
            <div>
                <h5> Leggi CO2 da ID lotto</h5>
            </div>
            <form onSubmit={(event) => {
                event.preventDefault()
                const id = this.productID.value
                this.getCO2ByID(id.toString())          
                }}>
            <div className="form-group mr-sm-2">
                <input
                    id="productPrice"
                    type="text"
                    ref={(input) => { this.productID = input }}
                    className="form-control"
                    placeholder="ID"
                required />
            </div>
            <button type="submit" className="btn btn-primary">aggiungi</button>
            </form>
            <div>
            </div>  
            <hr></hr>
            <div>
            </div>

        
            <h5> Inserisci Materia prima (solo produttore) </h5>
            <form onSubmit={(event) => {
                event.preventDefault()
                const name = this.pproductName.value
                const id = this.pproductID.value
                const gco2 = this.pproductCo2.value
                const quantity = this.pproductQty.value
                this.addMateriaPrima(name, id, gco2, quantity)
                }}>
            <div className="form-group mr-sm-2">
                <input
                id="productName"
                type="text"
                ref={(input) => { this.pproductName = input }}
                className="form-control"
                placeholder="Nome"
            required />
            </div>
            <div className="form-group mr-sm-2">
                <input
                id="productPrice"
                type="text"
                ref={(input) => { this.pproductID = input }}
                className="form-control"
                placeholder="ID"
            required />
        </div>
        <div className="form-group mr-sm-2">
            <input
                id="productCo2"
                type="number"
                ref={(input) => { this.pproductCo2 = input }}
                className="form-control"
                placeholder="CO2 (g)"
            required />
        </div>
        <div className="form-group mr-sm-2">
            <input
                id="productQuantity"
                type="number"
                ref={(input) => { this.pproductQty = input }}
                className="form-control"
                placeholder="Quantità"
            required />
        </div>
        <button type="submit" className="btn btn-primary">aggiungi</button>
        </form>
        <div>
        </div>
        <hr></hr>
        <div>
        </div>


            <h5> Inserisci Prodotto trasformato (solo trasformatore) </h5>
            <form onSubmit={(event) => {
                event.preventDefault()
                const name = this.tproductName.value
                const id = this.tproductID.value
                const gco2 = this.tproductCo2.value
                const quantity = this.tproductQty.value
                const listUsedProd = this.tproductUsedList.value.toString().split(',')
                const listQtyProd = this.tproductQtyList.value.toString().split(',')
                this.addProdottoTrasformato(name, id, gco2, listUsedProd, listQtyProd, quantity)
            }}>
        <div className="form-group mr-sm-2">
            <input
                id="productName"
                type="text"
                ref={(input) => { this.tproductName = input }}
                className="form-control"
                placeholder="Nome"
            required />
        </div>
        <div className="form-group mr-sm-2">
            <input
                id="productPrice"
                type="text"
                ref={(input) => { this.tproductID = input }}
                className="form-control"
                placeholder="ID"
            required />
        </div>
        <div className="form-group mr-sm-2">
            <input
                id="productCo2"
                type="number"
                ref={(input) => { this.tproductCo2 = input }}
                className="form-control"
                placeholder="CO2 (g)"
            required />
        </div>
        <div className="form-group mr-sm-2">
            <input
                id="productQuantity"
                type="number"
                ref={(input) => { this.tproductQty = input }}
                className="form-control"
                placeholder="Quantità"
            required />
        </div>
        <div className="form-group mr-sm-2">
            <input
                id="productPrice"
                type="text"
                ref={(input) => { this.tproductUsedList = input }}
                className="form-control"
                placeholder="Lista Prodotti usati per la trasformazione"
            required />
        </div>
        <div className="form-group mr-sm-2">
            <input
                id="productPrice"
                type="text"
                ref={(input) => { this.tproductQtyList = input }}
                className="form-control"
                placeholder="Quantità prodotti usati per la trasformazione"
            required />
        </div>
        <button type="submit" className="btn btn-primary">aggiungi</button>
        </form>
        <div>
        </div>
        <hr></hr>

        
        <p>&nbsp;</p>
        <h2>Lista prodotti</h2>
        <table className="table">
            <thead>
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col">Nomw</th>
                    <th scope="col">Co2 (g)</th>
                    <th scope="col">Quantità</th>
                    <th scope="col"></th>
                </tr>
            </thead>
            <tbody id="productList">
                { this.state.listOfProducts.map((product, key) => { return(
                    <tr key={key}>
                        <th scope="row">{product.id.toString()}</th>
                        <td>{product.name.toString()}</td>
                        <td>{product.gco2.toString()}</td>
                        <td>{product.quantity.toString()}</td>
                    </tr>
                 )})}   
            </tbody>
        </table>      
        </div>
        );
    }
}


export default App;
