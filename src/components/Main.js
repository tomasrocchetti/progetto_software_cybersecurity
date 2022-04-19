import React, { Component } from 'react';

class Main extends Component {

  render() {
    return (
      <div id="content">
        <h1>Aggiungi un Prodotto</h1>
        <form onSubmit={(event) => {
          event.preventDefault()
          const name = this.productName.value
          const id = window.web3.utils.toWei(this.productID.value.toString(), 'Ether')
          const gco2 = this.productCo2.value
          const quantity = this.productQty.value
          this.props.addMateriaPrima(name, id, gco2, quantity)
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
        
      </div>
    );
  }
}

export default Main;
