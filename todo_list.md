## Entro 1 maggio
- ~~Caricare i valori dei prodotti negli array~~
- ~~Caricarre i valori degli array in una tabella che elenca i prodotti~~
- ~~Refresh pagina after addMateriaPrima~~
- ~~passare indirizzi al costruttore (o indirizzi hardcoded?)~~
- ~~abilitare trasferimento token~~
- ~~sanificazione input array prodotti usati~~
- ~~aggiunto owner alla lista~~
- ~~bruciare i token qunado il prodotto viene trasformato~~
- ~~controllare che l'array di prodotti usati contenga solo integer~~
- capire come gestire gli errori, cosi non funzionano bene
- ~~passare gli address con i privilegi~~
- ~~listare componenti utilizzate~~


## Entro 6 maggio
- ~~Gestione Errori~~
  - ~~inserimento dati non corretti nell'array~~
  - ~~inserimento lettere al posto di uint~~
  - ~~ID gia esistente (c'è gia require su contract)~~
  - ~~l'utente non ha abbastanza permessi (c'è gia require su contract)~~

## Entro 12 maggio
- ~~Creare il JS per il Trasformatore (come produttore ma con piu voci)~~
- ~~Creare il JS per il Cliente (lista piu pulsante per visualizzare info prodotto da ID~~

- Fine

### Stato attuale
- Contratto funzionante ~~senza la gestione dei token~~, il costruttore non viene considerato, l'indirizzo del produttore è hardcoded nel contratto.
- L'interfaccia web è in grado di scrivere i dati della matteria prima sulla blockchain. 
- Il codice JS è in grado di leggere dalla blockchain ~~ma non è in grado di mostrarli sull'interfaccia web~~
- Le eccezioni vengono gestite
- ora l'id viene generato automaticamente a partire dalla data YYYYMMDDhhmmss
