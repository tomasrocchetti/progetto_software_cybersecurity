# progetto_software_cybersecurity

### Usage instructions for dummies

Install [Metamask](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=it) from Chrome extensions store

In Metamask go to ```settings > network > Add a network```:
Network name: my network
URL RPC: 192.168.1.50:7545
Chain ID: 1337

Now you can import some addresses from the chain to Metamask, these are some private keys for importing:
```eebf0a958e8ee4cb847f8092cbeef306cc171298f70eb58595fd834fb1a51d82```
```fcdb750ce7595b57c01cd61ffc28fd3df238684b7fc720b67d9b11c266f769ce```
```ca6eee18649acd7a0ea8ecfa61597f22b82f20522a9b9c9b6d8999442fda2b2e```
Please don't show these private keys to anyone, they contain 100ETH each 😜

Use the same browser where you installed metamask to go ```http://192.168.1.50:3000```

Enjoy

### Installation instructions for experts
Install [Ganache](https://trufflesuite.com/ganache/), install it and initialize, you should have now an instance of Ganache runnging on ```http://127.0.0.1:7545```. This is you local blockchain.

Install [Metamask](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=it) from Chrome extensions store and configure it to work with Ganache.

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
Install OpenZeppelin Library
```
npm install --save-exact openzeppelin-solidity
```
Compile smart contracts with 
```
truffle compile
```
Deploy with
```
truffle migrate
```
Now you can run the App
```
npm run start
```
Finally you can interact with the app via Chrome ```http://127.0.0.1:3000```
