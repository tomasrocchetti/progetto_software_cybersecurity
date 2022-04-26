# progetto_software_cybersecurity

### Istruzioni di utilizzo per dilettanti

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

Divertiteci e prestate attenzione alle emissioni di CO2 🌿

### Installazione locale (per utenti esperti)
Install [Ganache](https://trufflesuite.com/ganache/), install it and initialize, you should have now an instance of Ganache runnging on ```http://127.0.0.1:7545```. This is you local blockchain.

Install [Metamask](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=it) from Chrome extensions store and configure it to work with Ganache by going to ```settings > network > Add a network``` and using the following settings:  
**Network name:** my network  
**URL RPC:** http://127.0.0.1:7545  
**Chain ID:** 1337

Import some wallet addresses from Ganache to Metamask by the private keys provided by Ganache

Then you need to clone the repository on your computer:

```
git clone https://github.com/tomasrocchetti/progetto_software_cybersecurity.git
```
Navigate inside the project folder

```
cd progetto_software_cybersecurity
```

It is recommended to recompile the smart contracts, so If there are files with json extension inside the ```/src/abis``` directory it is recommended to delete them

Dependencies can now be installed
```
npm install
```
Install OpenZeppelin Library to manage ERC721 NFTs
```
npm install --save-exact openzeppelin-solidity
```
Compile smart contract with 
```
truffle compile
```
Deploy with
```
truffle migrate
```
Now you can run the App with
```
npm run start
```
Finally you can interact with the app via your browser at ```http://127.0.0.1:3000```

You can also import NFT in Metamask going to ```account > import tokens``` and inserting the contract address
