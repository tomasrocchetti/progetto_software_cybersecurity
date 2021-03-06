import React, { Component } from 'react';
import Web3 from 'web3'
import './App.css';
import Transactions from '../abis/Transactions.json'

class App extends Component {

    state = {
        listOfProducts: [],
        usedProds: [],
        loadPage: false
    };
  

    /**
    funzoine per tentare di caricare le componenti necessarie al funzionamento,
    se non è possibile caricare correttamente le componenti setta false la variabile che decide se caricare o meno la pagina
    **/
    async componentWillMount() {
        if(await this.loadWeb3()){
            this.state.loadPage = true;
            await this.loadBlockchainData()
        }     
    }

    /**
    viene caricato web3 e restituito lo stato di successo o insuccesso
    **/
    async loadWeb3() {
        if (window.ethereum) {
            window.web3 = new Web3(window.ethereum)
            await window.ethereum.enable()
            return true;
        }
        else if (window.web3) {
            window.web3 = new Web3(window.web3.currentProvider)
            return true;
        }
        else {
            window.alert('Browser non compatibile con Ethereum, installa MetaMask dallo store delle estensioni di chrome')
            return false;
        }
    }

    /**
    viene connessa la blockchain e caricato il contratto,
    vengono caricati tutti i prodotti con i vsari attributi nella lista listOfProducts,
    se qualcosa va storto viene restituito un messaggio di errore
    **/
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
            //window.alert("numero prodotti: " +len)
            for(var i=0; i<len;i++){
                const mproductID = await marketplace.methods.productIDs(i).call();
                const mgCO2 = await marketplace.methods.getCO2ByID(mproductID.toString()).call();
                const mprodQty = await marketplace.methods.getQtyByID(mproductID.toString()).call();
                const mprodName = await marketplace.methods.getNameByID(mproductID.toString()).call();
                const mprodOwner = await marketplace.methods.getOwner(mproductID).call();
                const prd ={name:mprodName, id: mproductID, gco2: mgCO2, quantity: mprodQty, owner: mprodOwner };
                this.state.listOfProducts[i] = prd
            }
        this.setState({ marketplace })
        } else {
            window.alert('Impossiblie fare il deploy del contratto')
        }
    }
   
    /**
    funzione che genera gli ID per prodotti e token associati a partire da data e ora.
    l'ID che viene generato è un intero in questa forma: YYYYMMDDhhmmss
    **/
    genID(){
        var currentdate = new Date(); 
        var idLotto = 
        + currentdate.getFullYear()*10000000000
        + (currentdate.getMonth()+1) *100000000
        + currentdate.getDate()*1000000
        + currentdate.getHours() *10000
        + currentdate.getMinutes()*100
        + currentdate.getSeconds()
        return idLotto;
    }

    /**
    funzione per caricare un prodotto (materia prima), sia che l'istruzione termina con successo, sia che termina in errore
    viene restituito un messaggio e viene refreshata la pagina
    **/
    addMateriaPrima(name, gco2, quantity) {
        this.state.marketplace.methods.addMateriaPrima(name, this.genID(), gco2, quantity).send({ from: this.state.account }).on('error', (error) =>{
            window.alert('Qualcosa è andato storto, la transazione non è stata completata');
            window.location.reload();
        }).on('confirmation', (confirmation) => {
            window.alert('La transazione è stata completata');
            window.location.reload();
        });
    }

    /**
    funzione per caricare un prodotto (prodotto lavorato), sia che l'istruzione termina con successo, sia che termina in errore
    viene restituito un messaggio e viene refreshata la pagina.
    viene inoltre effettuata una sanificazione degli input per far si che i valori in ingresso dell'array 
    contenente la lista dei prodotti usati per la lavorazione siano valori che non mandino in crash il sistema
    **/
    addProdottoLavorato(name, gco2, usedProd, quantity) {
        var usedProdContainUint = true;
        for (var i = 0; i<usedProd.length; i++){
            if (!this.isPositiveInteger(usedProd[i])){
                usedProdContainUint = false;
            }
        }
        if(usedProdContainUint){
            this.state.marketplace.methods.addProdottoLavorato(name, this.genID(), gco2, usedProd, quantity).send({ from: this.state.account }).on('error', (error) =>{
            window.alert('Qualcosa è andato storto, la transazione non è stata completata');
            window.location.reload();
        }).on('confirmation', (confirmation) => {
            window.alert('La transazione è stata completata');
            window.location.reload();
        });
        } else{
            window.alert('Hai inserito valori non accettabili tra gli ID dei prodotti usati nella lavorazione');
            window.location.reload();
        }
    }
    
    /**
    funzione che dato in ingresso un ID restituisce il valore del carbon footprint associato
    o dice che il prodotto non esiste se non c'è nessun carbon footprint associato
    **/
    async getCO2ByID(id){
        const gCO2 =  await this.state.marketplace.methods.getCO2ByID(id).call();
        const name = await this.state.marketplace.methods.getNameByID(id).call();
        const owner = await this.state.marketplace.methods.getOwner(id).call();
        this.state.usedProds = await this.state.marketplace.methods.getUsedProductForTransform(id).call();
        var infoTransformation = '';
        for (var i = 0; i<this.state.usedProds.length; i++){
            const carbonList= await this.state.marketplace.methods.getCO2ByID(this.state.usedProds[i]).call();
            infoTransformation =  infoTransformation  + this.state.usedProds[i]+ ' (' + carbonList+'g CO2)\n';
        }
        if(Number(gCO2) === 0){
            window.alert('Il prodotto con ID "' + id + '" non esiste');
        } else{
            window.alert('ID: ' + id + '\nNome: '+ name +'\nFootprint: ' + gCO2 + ' grammi di CO2 \nPossessore: ' + owner + ' \n \nPer perodurre questo prodotto sono stati utilizzati i prodotti con ID: \n' + infoTransformation);
        }
    }
    
    /**
    funzione per trasferire un token dato indirizzo del destinatatio e ID del token associato al prodotto
    l'utente viene avvisato sia in caso di successo che in caso di errore
    inoltre viene controllato se la stringa inserita nel campo indirizzo è un indirizzo valido
    **/
    transferToken(toAddress, tokenId){
        if(window.web3.utils.isAddress(toAddress)){
            this.state.marketplace.methods.transferToken(toAddress, tokenId).send({ from: this.state.account }).on('error', (error) =>{
                window.alert('Qualcosa è andato storto, la transazione non è stata completata');
                window.location.reload();
            }).on('confirmation', (confirmation) => {
                window.alert('La transazione è stata completata');
                window.location.reload();
        });
        } else{
            window.alert(toAddress + ' non è un indirizzo valido');
        }
    }
    
    /**
    funzione che data in ingresso una stringa controlla se è un intero positivo
    **/
    isPositiveInteger(str) {
        if (typeof str !== 'string') {
            return false;
            }
        const num = Number(str);
        if (Number.isInteger(num) && num > 0) {
            return true;
            }
        return false;
    }
    
    /**
    funzione che permette di settare gli indirizzi che hanno il permesso di eseguire le operazioni come
    produttori e quelli che hanno il permesso di eseguire le operazioni da produttore
    **/
    async setAddresses(fornitoreAddress, produttoreAddress){
        if(window.web3.utils.isAddress(fornitoreAddress) && window.web3.utils.isAddress(produttoreAddress)){
            await this.state.marketplace.methods.setAddresses(fornitoreAddress, produttoreAddress).send({ from: this.state.account }).on('error', (error) =>{
                window.alert('Qualcosa è andato storto, gli indirizzi non sono stati settati');
                window.location.reload();
            }).on('confirmation', (confirmation) => {
                window.alert('gli indirizzi sono stati settati');
                window.location.reload();
        });
        } else{
             window.alert('uno degli indirizzi non è valido');
        }
    }

    /**
    rendering della pagina.
    se la variabile di stato loadPage = true viene caricata lapagina, altrimenti viene caricata una pagina
    che invita l'utente ad installare o attivare metamask
    **/
    render() {
        if (this.state.loadPage){
            return (
                <div id="content">
                <h1>Carbon Footprint Tracker</h1>
                <h9>Il tuo indirizzo è: {this.state.account}</h9>
                <hr></hr>
        
                <div>
                <h5> Configura Indirizzi</h5>
                Questa funzione ti permette di associare a fornitore e produttore i relativi indirizzi. Puoi inserire un qualsiasi indirizzo tra quelli che ha generato la tua blockchian locale.
                </div>
                <form onSubmit={(event) => {
                    event.preventDefault()
                    const produttoreAddress = this.produttoreAddress.value
                    const fornitoreAddress = this.fornitoreAddress.value
                    this.setAddresses(fornitoreAddress, produttoreAddress)
                    }}>
                <div className="form-group mr-sm-2">
                    <input
                        id="productPrice"
                        type="text"
                        ref={(input) => { this.produttoreAddress = input }}
                        className="form-control"
                        placeholder="Indirizzo produttore"
                    required />
                </div>
                <div className="form-group mr-sm-2">
                    <input
                        id="productPrice"
                        type="text"
                        ref={(input) => { this.fornitoreAddress = input }}
                        className="form-control"
                        placeholder="Indirizzo fornitore"
                    required />
                </div>
                <button type="submit" className="btn btn-primary">configura indirizzi</button>
                </form>
                <div>
                </div>  
                <hr></hr>
                <div>
                </div>

                <div>
                <h5> Ottieni info Prodotto</h5>
                Qui puoi inserire un ID di un prodotto per ottenere le informazioni relative al suo impatto energetico. Se inserisci un ID di un prodotto lavorato verranno anche elencati tutti i prodotti utilizzati nella lavorazione.

                </div>
                <form onSubmit={(event) => {
                    event.preventDefault()
                    const id = this.productID.value
                    this.getCO2ByID(id.toString())          
                    }}>
                <div className="form-group mr-sm-2">
                    <input
                        id="productPrice"
                        type="number"
                        min="0"
                        step="1"
                        ref={(input) => { this.productID = input }}
                        className="form-control"
                        placeholder="ID (es. 20220304112330)"
                    required />
                </div>
                <button type="submit" className="btn btn-primary">leggi info</button>
                </form>
                <div>
                </div>  
                <hr></hr>
                <div>
                </div>


                <div>
                <h5> Trasferisci Token</h5>
                Questa funzione ti permette di trasferire il Token non fungibile associato ad un prodotto dal tuo wallet al wallet di qualcun altro. Puoi trasferire soltanto Token di tua proprietà.
                </div>
                <form onSubmit={(event) => {
                    event.preventDefault()
                    const tokenId = this.tokenID.value
                    const receiverAddress = this.receiverAddress.value
                    this.transferToken(receiverAddress, tokenId)          
                    }}>
                <div className="form-group mr-sm-2">
                    <input
                        id="productPrice"
                        type="number"
                        min="0"
                        step="1"
                        ref={(input) => { this.tokenID = input }}
                        className="form-control"
                        placeholder="Token ID"
                    required />
                </div>
                <div className="form-group mr-sm-2">
                    <input
                        id="productPrice"
                        type="text"
                        ref={(input) => { this.receiverAddress = input }}
                        className="form-control"
                        placeholder="Indirizzo"
                    required />
                </div>
                <button type="submit" className="btn btn-primary">trasferisci Token</button>
                </form>
                <div>
                </div>  
                <hr></hr>
                <div>
                </div>


                <h5> Inserisci Materia prima (solo fornitore) </h5>
                Questa funzione ti permette di aggiungere una nuova materia prima. Soltanto il wallet con privilegi di fornitore può utilizzare questa funzione. inoltre non è necessario inserire un ID, questo verrà generato automaticamente.
                Questa funzione genera un Token con stesso id del prodotto e lo aggiunge al wallet dell indirizzo che ha aggiunto la materia prima.
                <form onSubmit={(event) => {
                    event.preventDefault()
                    const name = this.pproductName.value
                    const gco2 = this.pproductCo2.value
                    const quantity = this.pproductQty.value
                    this.addMateriaPrima(name, gco2, quantity)
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
                    id="productCo2"
                    type="number"
                    min="0"
                    step="1"
                    ref={(input) => { this.pproductCo2 = input }}
                    className="form-control"
                    placeholder="CO2 (g)"
                required />
            </div>
            <div className="form-group mr-sm-2">
                <input
                    id="productQuantity"
                    type="number"
                    min="0"
                    step="1"
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


                <h5> Inserisci Prodotto lavorato (solo produttore) </h5>
                Questa funzione ti permette di aggiungere un nuovo prodotto lavorato. Soltanto il wallet con privilegi di produttore può utilizzare questa funzione. inoltre non è necessario inserire un ID, questo verrà generato automaticamente. Per inserire gli ID dei prodotti utilizzati nella lavorazione è sufficiente scrivere gli ID separati da una virgola.
                 Questa funzione, oltre a generare un nuovo token nel portafoglio di chi ha eseguito la funzione, brucia i token associati ai prodotti lavorati. Per questo motivo è possibile inserire dei prodotti nell elenco dei prodotti usati nella lavorazione solo se si è in possesso di essi, altrimenti verrà restituito un errore.
                 Un prodotto usato per la lavorazione può sia essere una materia prima che un prodotto già precedentemente lavorato.

                <form onSubmit={(event) => {
                    event.preventDefault()
                    const name = this.tproductName.value
                    const gco2 = this.tproductCo2.value
                    const quantity = this.tproductQty.value
                    const listUsedProd = this.tproductUsedList.value.toString().replace(/\s/g, '').split(',')
                    this.addProdottoLavorato(name, gco2, listUsedProd, quantity)
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
                    id="productCo2"
                    type="number"
                    min="0"
                    step="1"
                    ref={(input) => { this.tproductCo2 = input }}
                    className="form-control"
                    placeholder="CO2 (g)"
                required />
            </div>
            <div className="form-group mr-sm-2">
                <input
                    id="productQuantity"
                    type="number"
                    min="0"
                    step="1"
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
                    placeholder="Lista Prodotti usati per la lavorazione"
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
                        <th scope="col">Nome</th>
                        <th scope="col">Co2 (g)</th>
                        <th scope="col">Quantità</th>
                        <th scope="col">Possessore</th>
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
                            <td>{product.owner.toString()}</td>
                        </tr>
                     )})}   
                </tbody>
            </table>      
            </div>
            );
        } else{
            return(
                <div id="content">
                <h1>Installa o attiva Metamask</h1>
                </div>
                );
        }
        
            
    }
}


export default App;
