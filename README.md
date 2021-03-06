# 🌿 Carbon Footprint Tracker

## ⚙️ Descrizione dell'applicazione
Questa applicazione ci permette di tenere traccia di tutte le emissioni di CO2 emesse nel ciclo di vita di un prodotto, dalla produzione della materia prima all'arrivo del prodotto al consumatore, passando per le varie trasformazioni che possono essere fatte su un prodotto.

Possiamo schematizzare il funzionamento in questo modo:
- Un fornitore fornisce una materia prima (ad esempio acqua, uova, grano).
- Il fornitore trasferisce la pripria materia prima ad un produttore.
- Il produttore utilizza le materie prime in proprio possesso per produrre un prodotto lavorato (ad esemprio trasforma il grano in farina).
- Il produttore ora può proseguire in 2 direzioni:
   - Trasferire il prodotto lavorato direttamente ad un cliente.
   - Trasferire il prodotto lavorato ad un altro produttore (ad esempio vende la farina ad un produttore per produrre pasta).
- Chiunque puo leggere le informazioni sul carbon footprint e tracciare la storia di trasformazione dei prodotti

Ovviamente per completare la trasformazione di un prodotto verrà emessa una certa quantità di CO2, pertanto quando viene generato un prodotto trasformato si sommano i Carbon Footprint delle materie prime alla quantità di CO2 emessa in fase di trasformazione.


Ogni prodotto è direttamnte associato ad un NFT per garantire l'autenticità del prodotto stesso e del suo Carbon Footprint.

## 👩‍💻 Interfaccia utente
L'interfaccia utente è stata suddivisa in 6 blocchi, ciascuno con una specifica funzione, analizziamo quindi i blocchi uno ad uno:

#### 1️⃣ Configura indirizzi
Questo blocco permette di scegliere quale indirizzo ha la possibilità di eseguire le operazioni con i privilegi di fornitore (ovvero aggiungere materie prime) e quale indirizzo ha la possibilità di eseguire operazioni con i privilegi di produttore (ovvero aggiungere prodotti trasformati).  
Questa funzione puo essere utilizzata qualsiasi sia l'indirizzo che invoca il contratto. È soltanto una funzione per fare dei test con l'applicazione.
![indirizzi](/images/indirizzi.png)

#### 2️⃣ Leggi informazioni prodotto
Questo blocco permette, dato un ID, di ottenere tutte le informazioni di un prodotto, tra cui l'indirizzo del possessore del token associato a quel prodotto e una lista dei prodotti utilizzati nella lavorazione.  
È importante specificare che se l'indirizzo del possessore dovesse essere ```0x0000000000000000000000000``` significa che quel prodotto è gia stato utilizzato in una lavorazione, pertanto non esiste più (come ad esmpio il grano dopo che sia gia stata prodotta la farina).
![read_info](/images/read_info.png)

Nel momento in cui viene premuto il tasto di conferma il sito restituisce un alert con tutte le informazioni riguardanti il prodotto.
![alert_info](/images/alert_info.png)


#### 3️⃣ Trasferisci Token
Questa funzione ci permette di trasferire la proprietà degli NFT da un wallet ad un altro, questo si traduce nel trasferire la proprietà di un prodotto. Chiunque può utilizzare la funzione, ma la transazione andrà a buon fine soltanto se chi decide di trasferire il token è il proprietario dello stesso.

Questa funzione incorpora tecniche di sanificazione dell'input per verificare che l'indirizzo di destinazione sia effettivamente un indirizzo, ma non verifica in alcun modo che l'indirizzo di destinazione sia un indirizzo attivo, questo per lasciare all'utente la massima flessibilità sui trasferimenti dei token.
![token_transfer](/images/token_transfer.png)

#### 4️⃣ Inserisci materia prima
Questo blocco è utilizzabile soltanto dall'indirizzo del fornitore e permette di inserire nella lista di prodotti una nuova materia prima. La nuova materia prima inserita avrà associato un ID generato automaticamente in base alla data e all'ora. Insieme alla materia prima viene creato un NFT ad essa associato, con il medesimo ID. E viene accreditato nel portafogli di chi ha eseguito l'operazione di inserimento.
![materia_prima](/images/materia_prima.png)

#### 5️⃣ inserisci prodotto lavorato
Questo blocco è utilizzabile soltanto dall'indirizzo del produttore e permette di inserire nella lista dei prodotti un nuovo prodotto lavorato. Come nel caso dell'inserimento della materia prima viene generato un ID e viene generato un token associato al prodotto trasformato inserito. 

Nella fase di inserimento è possibile aggiungere la lista degli ID dei prodotti utilizzati per la lavorazione (ad esempio aggiungo farina e uova per produrre la pasta).  
Nella lista di prodotti utilizzati, ovviamente, è possibile inserire solo prodotti di proprietà dello stesso indirizzo che utilizza tale funzione, altrimenti all'utente viene segnalato un errore.  
I prodotti usati per la lavorazione non esistono più, pertanto gli NFT associati ad essi vengono bruciati 🔥.  
Viene generato un nuovo NFT associato al nuovo prodotto lavorato e viene aggiunto al wallet di chi ha fatto l'inserimento. 

La quantità di CO2 generata nella lavorazione viene sommata ai carbon footprint dei prodotti utilizzati in essa.
![prodotto_trasfo](/images/prodotto_trasfo.png)

#### 6️⃣ Lista prodotti
Questo blocco non contiene altro una tabella con tutti i prodotti e le relative caratteristiche.
![lista_prodotti](/images/lista_prodotti.png)

## 🐐 Istruzioni di utilizzo per dilettanti

Se non sei molto pratico e vuoi soltanto provare la nostra applicazione potresti considerare di collegarti alla nostra blockchain di test e accedere al Carbon Footprint Tracker direttamente sul nostro server via Browser. Per fare ciò ti basta installare e configurare Metamask, un wallet ethereum disponibile sia come applicazione Android/iOS che come estensione per Chrome o Firefox.

Per utilizzare l'estensione di Metamask per Chrome ti basta andare [qui](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=it) e premere installa.

Una volta installato e inizializzato Metemask è opportuno configurarlo per permettergli di interagire con la nostra blockchain di prova. Per farlo vai in ```settings > network > Add a network``` e usa la seguente configurazione per creare una nuova rete:  
 **Network name:** ```tnet```  
 **URL RPC:** ```HTTP://tomasrocchetti.ddns.net:8545```  
 **Chain ID:** ```1337```

 Ora che Metamask è finalmente in grado di interagire con la nostra blockchain di prova è possibile importare dei wallet preconfigurati. Lasciamo 3 chiavi private per poter importare 3 wallet della nostra blockchain di prova in metamask:  
 ```0x76491d17a9b21f787425589535a145b4a6ca6c4b4ae7a5f7dcddeb12d9032bff``` 
 ```0x8ff91ba5a909fd68cf4021d3a18e0498f7a115e78f54c3e9a3b0222bbc814267``` 
 ```0xed56f425d7cc079dbcc6f1c442900eb8da940981680c5fd99644041a7aeb88c1``` 

 Si prega di non mostrare a nessuno queste chiavi private, infatti ognuno di questi 3 wallet contiene 100ETH 😜


Ora è sufficiente utilizzare lo stesso browser in cui si è installato Metamask e navigare all'indirizzo http://tomasrocchetti.ddns.net:3000 per poter utilizzare la nostra app.

Se vuoi puoi importare in Metamask gli NFT che vengono generati con l'inserimento di nuovi prodotti. Per farlo è sufficiente aprire Metamask e andare in ```account > import tokens``` e inserire l'indirizzo del contratto deployato nella blockchain di prova, ovvero ```0x58f8385E6cd14b35B1CfCe2e539c307B0fa0056D```

Divertitevi con la nostra app e prestate attenzione alle emissioni di CO2 🌿

## 🧑‍🔬 Installazione locale (per utenti esperti)
Se sei un utente esperto puoi considerare di scaricare il nostro codice ed eseguirlo in locale sulla tua blockchain preferita, negli step successivi verrà presa in considerazione la blockchain Ganache.
#### 🔗 Preparazione della blockchain
Installa [Ganache](https://trufflesuite.com/ganache/), una volta aperta l'applicazione viene chiesto di configurarla, è sufficiente proseguire con le impostazioni predefinite. Una volta installata e inizializzata si avrà un'istanza di Ganache locale in ```http://127.0.0.1:7545```. Questa è la vostra blockchain locale di prova.

#### 🦊 Preparazione di Metamask
Per utilizzare l'estensione di Metamask per Chrome ti basta andare [qui](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=it) e premere installa.

Una volta installato e inizializzato Metemask è opportuno configurarlo per permettergli di interagire con la nostra blockchain di prova. Per farlo vai in ```settings > network > Add a network``` e usa la seguente configurazione per creare una nuova rete:  
**Network name:** ```my network```  
**URL RPC:** ```HTTP://localhost:7545```  
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
Si consiglia si installare globalmente Truffle con
```
npm install -g truffle
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
