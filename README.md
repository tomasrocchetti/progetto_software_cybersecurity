# progetto_software_cybersecurity

## Istruzioni di utilizzo per dilettanti

Se non sei molto pratico e vuoi soltanto provare la nostra applicazione potresti considerare di collegarti alla nostra blockchain di test e accedere al Carbon Footprint Tracker direttamente sul nostro server via Browser. Per fare ciò ti basta installare e configurare Metamask, un wallet ethereum disponibile sia come applicazione Android/iOS che come estensione per Chrome o Firefox.

Per utilizzare l'estensione di Metamask per Chrome ti basta andare [qui](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=it) e premere installa.

Una volta installato e inizializzato Metemask è opportuno configurarlo per permettergli di interagire con la nostra blockchain di prova. Per farlo vai in ```settings > network > Add a network``` e usa la seguente configurazione per creare una nuova rete:  
**Network name:** ```my network```  
**URL RPC:** ```http://93.56.201.59:7545```  
**Chain ID:** ```1337```

Ora che Metamask è finalmente in grado di interagire con la nostra blockchain di prova è possibile importare dei wallet preconfigurati. Lasciamo 3 chiavi private per poter importare 3 wallet della nostra blockchain di prova in metamask:
```eebf0a958e8ee4cb847f8092cbeef306cc171298f70eb58595fd834fb1a51d82```
```fcdb750ce7595b57c01cd61ffc28fd3df238684b7fc720b67d9b11c266f769ce```
```ca6eee18649acd7a0ea8ecfa61597f22b82f20522a9b9c9b6d8999442fda2b2e```

Si prega di non mostrare a nessuno queste chiavi private, infatti ognuno di questi 3 wallet contiene 100ETH 😜

Ora è sufficiente utilizzare lo stesso browser in cui si è installato Metamask e navigare all'indirizzo http://93.56.201.59:3000 per poter utilizzare la nostra app.

Se vuoi puoi importare in Metamask gli NFT che vengono generati con l'inserimento di nuovi prodotti. Per farlo è sufficiente aprire Metamask e andare in ```account > import tokens``` e inserire l'indirizzo del contratto deployato nella blockchain di prova, ovvero ```0x329847832yrfh478fh3487```

Divertitevi con la nostra app e prestate attenzione alle emissioni di CO2 🌿

## Installazione locale (per utenti esperti)
Se sei un utente esperto puoi considerare di scaricare il nostro codice ed eseguirlo in locale sulla tua blockchain preferita, negli step successivi verrà presa in considerazione la blockchain Ganache.
### Preparazione della blockchain
Installa [Ganache](https://trufflesuite.com/ganache/), una volta aperta l'applicazione viene chiesto di configurarla, è sufficiente proseguire con le impostazioni predefinite. Una volta installata e inizializzata si avrà un'istanza di Ganache locale in ```http://127.0.0.1:7545```. Questa è la vostra blockchain locale di prova.

### Preparazione di Metamask
Per utilizzare l'estensione di Metamask per Chrome ti basta andare [qui](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=it) e premere installa.

Una volta installato e inizializzato Metemask è opportuno configurarlo per permettergli di interagire con la nostra blockchain di prova. Per farlo vai in ```settings > network > Add a network``` e usa la seguente configurazione per creare una nuova rete:  
**Network name:** ```my network```  
**URL RPC:** ```http://localhost:7545```  
**Chain ID:** ```1337```

Ora che è tutto configurato non ci resta che visualizzare in Ganache le chiavi private associate ai nostri wallet e utilizzarle per importare i wallet in Metamask.

### Installazione dell'applicazione
Scaricare da github lo zip contenente il sorgente o clonare la repo con il comando

```
git clone https://github.com/tomasrocchetti/progetto_software_cybersecurity.git
```
Navigare nella cartella del progetto con

```
cd progetto_software_cybersecurity
```

È consigliabile ricompilare lo smart contract, se sono presenti dei file con estensione .json all'interno della cartella ```/src/abis``` si prega di eliminarli

Se necessario installare il gestore di pacchetti ```npm```.

Ora è possibile installare le dipendenze necessarie con
```
npm install
```
Installare inoltre le librerie OpenZeppelin, saranno necessarie per l'utilizzo degli NFT ERC721
```
npm install --save-exact openzeppelin-solidity
```
Compilare lo smart contract con
```
truffle compile
```
Fare il deploy dello smart contract con
```
truffle migrate
```
Infine occorre eseguire l'applicazione con
```
npm run start
```
Finalmente puoi interagire con l'applicazione locale aprendo il browser e navigando in ```http://127.0.0.1:3000```, si ricorda sempre di utilizzare il browser in cui è stato configurato Metamask

Puoi importare in Metamask gli NFT che vengono generati con l'inserimento di nuovi prodotti. Per farlo è sufficiente aprire Metamask e andare in ```account > import tokens``` e inserire l'indirizzo del contratto deployato, puoi ricavare quest'ultimo dall'interfaccia di Ganache.

Divertitevi con la nostra app e prestate attenzione alle emissioni di CO2 🌿
