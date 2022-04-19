import React, { Component } from 'react';
import Web3 from 'web3'
import logo from '../logo.png';
import './App.css';
import Transactions from '../abis/Transactions.json'
import Navbar from './Navbar'
import Main from './Main'

class App extends Component {

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
    // Load account
    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })
    const networkId = await web3.eth.net.getId()
    const networkData = Transactions.networks[networkId]
    if(networkData) {
      const marketplace = web3.eth.Contract(Transactions.abi, networkData.address)
      const res = await marketplace.methods.getCO2ByID('6667').call();
    window.alert(res)
              this.setState({ marketplace })
    } else {
      window.alert('Marketplace contract not deployed to detected network.')
    }
    
  }

  addMateriaPrima(name, id, gco2, quantity) {
    this.setState({ loading: true })
    this.state.marketplace.methods.addMateriaPrima(name, id, gco2, quantity).send({ from: this.state.account })
    .once('receipt', (receipt) => {
      this.setState({ loading: false })
    })
  }
    

  

   render() {
    return (
    
      <div id="content">
        <h1>Aggiungi un Prodotto</h1>
        <form onSubmit={(event) => {
          event.preventDefault()
          const name = this.productName.value
          const id = this.productID.value
          const gco2 = this.productCo2.value
          const quantity = this.productQty.value
          this.addMateriaPrima(name, id, gco2, quantity)
          let result;
          
        }}>
          <div className="form-group mr-sm-2">
            <input
              id="productName"
              type="text"
              ref={(input) => { this.productName = input }}
              className="form-control"
              placeholder="Nome"
              required />
          </div>
          <div className="form-group mr-sm-2">
            <input
              id="productPrice"
              type="text"
              ref={(input) => { this.productID = input }}
              className="form-control"
              placeholder="ID"
              required />
          </div>
         <div className="form-group mr-sm-2">
            <input
              id="productCo2"
              type="text"
              ref={(input) => { this.productCo2 = input }}
              className="form-control"
              placeholder="CO2 (g)"
              required />
          </div>
        <div className="form-group mr-sm-2">
            <input
              id="productQuantity"
              type="text"
              ref={(input) => { this.productQty = input }}
              className="form-control"
              placeholder="Quantità"
              required />
          </div>
          <button type="submit" className="btn btn-primary">aggiungi</button>
        </form>
                <p>&nbsp;</p>
        <h2>Buy Product</h2>
        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">Name</th>
              <th scope="col">Price</th>
              <th scope="col">Owner</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <tbody id="productList">
        <th scope="col"></th>
          </tbody>
        </table>
      </div>
    );
  }
}

export default App;
