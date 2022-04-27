# 🌿 Carbon Footprint Tracker

## ⚙️ Descrizione dell'applicazione
Questa applicazione ci permette di tenere traccia di tutte le emissioni di CO2 emesse nel ciclo di vita di un prodotto, dalla produzione della materia prima all'arrivo del prodotto al consumatore, passando per le varie trasformazioni che possono essere fatte su un prodotto.

Possiamo schematizzare il funzionamento in questo modo:
- Un produttore produce una materia prima (ad esempio acqua, uova, grano).
- Il produttore trasferisce la pripria materia prima ad un trasformatore.
- Il trasformatore utilizza le materie prime in proprio possesso per generare un prodotto lavorato (ad esemprio trasforma il grano in farina).
- Il trasformatore ora può proseguire in 2 direzioni:
   - Trasferire il prodotto trasformato direttamente ad un cliente.
   - Trasferire il prodotto trasformato ad un altro trasformatore (ad esempio vende la farina ad un trasformatore per produrre pasta).

Ovviamente per completare la trasformazione di un prodotto verrà emessa una certa quantità di CO2, pertanto quando viene generato un prodotto trasformato si sommano i Carbon Footprint delle materie prime alla quantità di CO2 emessa in fase di trasformazione.


Ogni prodotto è direttamnte associato ad un NFT per garantire l'autenticità del prodotto stesso e del suo Carbon Footprint.

## 👩‍💻 Interfaccia utente
L'interfaccia utente è stata suddivisa in 6 blocchi, ciascuno con una specifica funzione, analizziamo quindi i blocchi uno ad uno:

#### 1️⃣ Configura indirizzi
Questo blocco permette di scegliere quale indirizzo ha la possibilità di eseguire le operazioni con i privilegi di produttore (ovvero aggiungere materie prime) e quale indirizzo ha la possibilità di eseguire operazioni con i privilegi di trasformatore (ovvero aggiungere prodotti trasformati).  
Questa funzione puo essere utilizzata qualsiasi sia l'indirizzo che invoca il contratto. È soltanto una funzione per fare dei test con l'applicazione.

#### 2️⃣ Leggi informazioni prodotto
Questo blocco permette, dato un ID, di ottenere tutte le informazioni di un prodotto, tra cui l'indirizzo del possessore del token associato a quel prodotto e una lista dei prodotti utilizzati nella trasformazione.  
È importante specificare che se l'indirizzo del possessore dovesse essere ```0x0000000000000000000000000``` significa che quel prodotto è gia stato utilizzato in una trasformazione, pertanto non esiste più (come ad esmpio il grano dopo che sia gia stata prodotta la farina).

#### 3️⃣ Trasferisci Token
Questa funzione ci permette di trasferire la proprietà degli NFT da un wallet ad un altro, questo si traduce nel trasferire la proprietà di un prodotto. Chiunque può utilizzare la funzione, ma la transazione andrà a buon fine soltanto se chi decide di trasferire il token è il proprietario dello stesso.

Questa funzione incorpora tecniche di sanificazione dell'input per verificare che l'indirizzo di destinazione sia effettivamente un indirizzo, ma non verifica in alcun modo che l'indirizzo di destinazione sia un indirizzo attivo, questo per lasciare all'utente la massima flessibilità sui trasferimenti dei token.

#### 4️⃣ Inserisci materia prima
Questo blocco è utilizzabile soltanto dall'indirizzo del produttore e permette di inserire nella lista di prodotti una nuova materia prima. La nuova materia prima inserita avrà associato un ID generato automaticamente in base alla data e all'ora. Insieme alla materia prima viene creato un NFT ad essa associato, con il medesimo ID. E viene accreditato nel portafogli di chi ha eseguito l'operazione di inserimento.

#### 5️⃣ inserisci prodotto trasformato
Questo blocco è utilizzabile soltanto dall'indirizzo del trasformatore e permette di inserire nella lista dei prodotti un nuovo prodotto trasformato. Come nel caso dell'inserimento della materia prima viene generato un ID e viene generato un token associato al prodotto trasformato inserito. 

Nella fase di inserimento è possibile aggiungere la lista degli ID dei prodotti utilizzati per la trasformazione (ad esempio aggiungo farina e uova per produrre la pasta).  
Nella lista di prodotti utilizzati, ovviamente, è possibile inserire solo prodotti di proprietà dello stesso indirizzo che utilizza la funzione di inserimento del prodotto trasformato, altrimenti all'utente viene segnalato un errore.  
I prodotti usati per la trasformazione non esistono più, pertanto gli NFT associati ad essi vengono bruciati 🔥.  
Viene generato un nuovo NFT associato al nuovo prodotto trasformato e viene aggiunto al wallet di chi ha fatto l'inserimento. 

La quantità di CO2 generata nella trasformazione viene sommata ai carbon footprint dei prodotti utilizzati nella trasformaizone.

#### 6️⃣ Lista prodotti
Questo blocco non contiene altro una tabella con tutti i prodotti e le relative caratteristiche.

## 🐐 Istruzioni di utilizzo per dilettanti

Se non sei molto pratico e vuoi soltanto provare la nostra applicazione potresti considerare di collegarti alla nostra blockchain di test e accedere al Carbon Footprint Tracker direttamente sul nostro server via Browser. Per fare ciò ti basta installare e configurare Metamask, un wallet ethereum disponibile sia come applicazione Android/iOS che come estensione per Chrome o Firefox.

Per utilizzare l'estensione di Metamask per Chrome ti basta andare [qui](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=it) e premere installa.

Una volta installato e inizializzato Metemask è opportuno configurarlo per permettergli di interagire con la nostra blockchain di prova. Per farlo vai in ```settings > network > Add a network``` e usa la seguente configurazione per creare una nuova rete:  
**Network name:** ```tnet```  
**URL RPC:** ```http://tomasrocchetti.ddns.net:7545```  
**Chain ID:** ```1337```

Ora che Metamask è finalmente in grado di interagire con la nostra blockchain di prova è possibile importare dei wallet preconfigurati. Lasciamo 3 chiavi private per poter importare 3 wallet della nostra blockchain di prova in metamask:
```3e5296e81405c52abd8f88493f1683898ed9731067687ad05b100e39ade3faf2```
```00fc46ffdae44f324e028c61b301fc3465e19f318165c0e2193ff6c2a647bb42```
```2452fe5af8d0154b2c6bd51671275e412459e06fcafb49a7129e98ab05fa312a```

Si prega di non mostrare a nessuno queste chiavi private, infatti ognuno di questi 3 wallet contiene 100ETH 😜

Ora è sufficiente utilizzare lo stesso browser in cui si è installato Metamask e navigare all'indirizzo http://tomasrocchetti.ddns.net:3000 per poter utilizzare la nostra app.

Se vuoi puoi importare in Metamask gli NFT che vengono generati con l'inserimento di nuovi prodotti. Per farlo è sufficiente aprire Metamask e andare in ```account > import tokens``` e inserire l'indirizzo del contratto deployato nella blockchain di prova, ovvero ```0xf02F26b2D0120C2459823aA5E2151C67a2CbDe97```

Divertitevi con la nostra app e prestate attenzione alle emissioni di CO2 🌿

## 🧑‍🔬 Installazione locale (per utenti esperti)
Se sei un utente esperto puoi considerare di scaricare il nostro codice ed eseguirlo in locale sulla tua blockchain preferita, negli step successivi verrà presa in considerazione la blockchain Ganache.
#### 🔗 Preparazione della blockchain
Installa [Ganache](https://trufflesuite.com/ganache/), una volta aperta l'applicazione viene chiesto di configurarla, è sufficiente proseguire con le impostazioni predefinite. Una volta installata e inizializzata si avrà un'istanza di Ganache locale in ```http://127.0.0.1:7545```. Questa è la vostra blockchain locale di prova.

#### 🦊 Preparazione di Metamask
Per utilizzare l'estensione di Metamask per Chrome ti basta andare [qui](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=it) e premere installa.

Una volta installato e inizializzato Metemask è opportuno configurarlo per permettergli di interagire con la nostra blockchain di prova. Per farlo vai in ```settings > network > Add a network``` e usa la seguente configurazione per creare una nuova rete:  
**Network name:** ```my network```  
**URL RPC:** ```http://localhost:7545```  
**Chain ID:** ```1337```

Ora che è tutto configurato non ci resta che visualizzare in Ganache le chiavi private associate ai nostri wallet e utilizzarle per importare i wallet in Metamask.

#### ⬇️ Installazione dell'applicazione
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
