# progetto_software_cybersecurity

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
