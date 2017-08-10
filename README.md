# BlockchainNetwork-CompositeJourney

## Build Your First Hyperledger Network

This project is focused on helping developer to run Hyperledger Fabric locally, then install and deploy Composer Business Network Archive(i.e. **.bna**) file on it.

## Prerequisite and setup

* [Docker](https://www.docker.com/products/overview) - v1.13 or higher
* [Docker Compose](https://docs.docker.com/compose/overview/) - v1.8 or higher
* [Node.js & npm](https://nodejs.org/en/download/) - node v6.2.0 - v6.10.0 (v7+ not supported); npm comes with your node installation.
* [Git client](https://git-scm.com/downloads) - needed for clone commands
*  git - 2.9.x
*  Python - 2.7.x

## Steps
1. [Installing Hyperledger Composer Development Tools](#1-installing-hyperledger-composer-development-tools)
2. [Starting Hyperledger Fabric](#2-starting-hyperledger-fabric)
3. [Generate the Business Network Archive (BNA)](#3-generate-the-business-network-archive-bna)
4. [Deploy the Business Network Archive using Composer Playground](#4-deploy-the-business-network-archive-using-composer-playground)
5. [Deploy the Business Network Archive on Hyperledger Composer running locally](#5-deploy-the-business-network-archive-on-hyperledger-composer-running-locally)

## 1. Installing Hyperledger Composer Development Tools

* The `composer-cli` contains all the command line operations for developing business networks. To install `composer-cli` run the following command:
```
npm install -g composer-cli
```

* The `generator-hyperledger-composer` is a Yeoman plugin that creates bespoke applications for your business network. To install `generator-hyperledger-composer` run the following command:
```
npm install -g generator-hyperledger-composer
```

* The `composer-rest-server` uses the Hyperledger Composer LoopBack Connector to connect to a business network, extract the models and then present a page containing the REST APIs that have been generated for the model. To install `composer-rest-server` run the following command:
```
npm install -g composer-rest-server
```

* `Yeoman` is a tool for generating applications. When combined with the `generator-hyperledger-composer` component, it can interpret business networks and generate applications based on them. To install `Yeoman` run the following command:
```
npm install -g yo
```

## 2. Starting Hyperledger Fabric

There are two version of Hyperledger Fabric: v0.6 and v1.0. Hyperledger Fabric v1.0 is highly recommended and the default. If for some reason v0.6 needs to be installed, you can set it explicitly as follows:
```bash
export FABRIC_VERSION=hlfv0.6
```
To unset a v.06 export or to explicitly use v1 Fabric, use the following command:
```bash
export FABRIC_VERSION=hlfv1
```
First download the docker files for Fabric. Then start the Fabric and create a Composer profile using the following commands:
```bash
./downloadFabric.sh
./startFabric.sh
./createComposerProfile.sh
```  

You can stop and tear down Fabric using:
```
./stopFabric.sh
./teardownFabric.sh
```

## 3. Generate the Business Network Archive (BNA)

This business network defines:

**Participant**
`Trader`

**Asset**
`Commodity`

**Transaction**
`Trade`

`Commodity` is owned by a `Trader`, and the owner of a `Commodity` can be modified by submitting a `Trade` transaction.

You can now generate a Business Network Archive (BNA) file for your business network definition. The BNA file is the deployable unit -- a file that can be deployed to the Composer runtime for execution.

Use the following command to generate the network archive:
```bash
npm install
```
You should see the following output:
```bash
Creating Business Network Archive

Looking for package.json of Business Network Definition
	Input directory: /Users/ishan/Documents/git-demo/BlockchainNetwork-CompositeJourney

Found:
	Description: Sample product auction network
	Name: my-network
	Identifier: my-network@0.0.1

Written Business Network Definition Archive file to
	Output file: ./dist/my-network.bna

Command succeeded
```

The `composer archive create` command has created a file called `my-network.bna` in the `dist` folder.

You can test the business network definition against the embedded runtime that stores the state of 'the blockchain' in-memory in a Node.js process. This embedded runtime is very useful for unit testing, as it allows you to focus on testing the business logic rather than configuring an entire Fabric.
From your project working directory (product-auction), open the file test/productAuction.js and run the following command:
```
npm test
```

## 4. Deploy the Business Network Archive using Composer Playground

Open [Composer Playground](http://composer-playground.mybluemix.net/), by default the Basic Sample Network is imported.
If you have previously used Playground, be sure to clear your browser local storage by running `localStorage.clear()` in your browser Console. Now import the `my-network.bna` file and click on deploy button.

>You can also setup [Composer Playground locally](https://hyperledger.github.io/composer/installing/using-playground-locally.html).

To test this Business Network Definition in the **Test** tab:

Create `Trader` participants:

```
{
  "$class": "org.acme.mynetwork.Trader",
  "tradeId": "traderA",
  "firstName": "Tobias",
  "lastName": "Funke"
}

{
  "$class": "org.acme.mynetwork.Trader",
  "tradeId": "traderB",
  "firstName": "Simon",
  "lastName": "Stone"
}
```

Create a `Commodity` asset with owner as `traderA`:
```
{
  "$class": "org.acme.mynetwork.Commodity",
  "tradingSymbol": "commodityA",
  "description": "Sample Commodity",
  "mainExchange": "Dollar",
  "quantity": 100,
  "owner": "resource:org.acme.mynetwork.Trader#traderA"
}
```

Submit a `Trade` transaction to change the owner of Commodity `commodityA`:
```
{
  "$class": "org.acme.mynetwork.Trade",
  "commodity": "resource:org.acme.mynetwork.Commodity#commodityA",
  "newOwner": "resource:org.acme.mynetwork.Trader#traderB"
}
```

You can verify the new owner by clicking on the `Commodity` registry. Also you can view all the transactions by selecting the `All Transactions` registry.

  ## 5. Deploy the Business Network Archive on Hyperledger Composer running locally

Change directory to the `dist` folder containing `product-auction.bna` file and type:
```
cd dist
composer network deploy -a my-network.bna -p hlfv1 -i PeerAdmin -s <randomString>
```

After sometime time business network should be deployed to the local Hyperledger Fabric. You should see the output as follows:
```
Deploying business network from archive: my-network.bna
Business network definition:
	Identifier: my-network@0.0.1
	Description: Sample product auction network

✔ Deploying business network definition. This may take a minute...


Command succeeded
```

You can verify that the network has been deployed by typing:
```
composer network ping -n product-auction -p hlfv1 -i admin -s adminpw
```

You should see the the output as follows:
```
The connection to the network was successfully tested: my-network
	version: 0.10.0
	participant: <no participant found>

Command succeeded  
```

To integrate with the deployed business network (creating assets/participants and submitting transactions) we can either use the Composer Node SDK or we can generate a REST API.
To create the REST API we need to launch the `composer-rest-server` and tell it how to connect to our deployed business network.
Now launch the server by changing directory to the product-auction folder and type:
```bash
cd ..
composer-rest-server
```

Answer the questions posed at startup. These allow the composer-rest-server to connect to Hyperledger Fabric and configure how the REST API is generated.
```
_   _                                 _              _                                  ____                                                         
| | | |  _   _   _ __     ___   _ __  | |   ___    __| |   __ _    ___   _ __           / ___|   ___    _ __ ___    _ __     ___    ___    ___   _ __
| |_| | | | | | | '_ \   / _ \ | '__| | |  / _ \  / _` |  / _` |  / _ \ | '__|  _____  | |      / _ \  | '_ ` _ \  | '_ \   / _ \  / __|  / _ \ | '__|
|  _  | | |_| | | |_) | |  __/ | |    | | |  __/ | (_| | | (_| | |  __/ | |    |_____| | |___  | (_) | | | | | | | | |_) | | (_) | \__ \ |  __/ | |   
|_| |_|  \__, | | .__/   \___| |_|    |_|  \___|  \__,_|  \__, |  \___| |_|             \____|  \___/  |_| |_| |_| | .__/   \___/  |___/  \___| |_|   
         |___/  |_|                                       |___/                                                    |_|                                
? Enter your Fabric Connection Profile Name: hlfv1
? Enter your Business Network Identifier : my-network
? Enter your Fabric username : admin
? Enter your secret: adminpw
? Specify if you want namespaces in the generated REST API: never use namespaces
? Specify if you want the generated REST API to be secured: No
```

If the composer-rest-server started successfully you should see these two lines are output:
```
Web server listening at: http://localhost:3000
Browse your REST API at http://localhost:3000/explorer
```

Open a web browser and navigate to http://localhost:3000/explorer

You should see the LoopBack API Explorer, allowing you to inspect and test the generated REST API. Follow the instructions to test Business Network Definition as mentioned above in the composer section.

## Additional Resources
* [Hyperledger Fabric Docs](http://hyperledger-fabric.readthedocs.io/en/latest/)
* [Hyperledger Composer Docs](https://hyperledger.github.io/composer/introduction/introduction.html)

## License
[Apache 2.0](LICENSE)
