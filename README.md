# BlockchainNetwork-CompositeJourney

## Build Your First Network (BYFN)

This project is focused on helping developer to setup a sample Hyperledger Fabric network consisting of two organizations, each maintaining two peer nodes, and a “solo” ordering service.

## Prerequisite

* [Go](https://golang.org/) - most recent version
* [Docker](https://www.docker.com/products/overview) - v1.13 or higher
* [Docker Compose](https://docs.docker.com/compose/overview/) - v1.8 or higher
* [Node.js & npm](https://nodejs.org/en/download/) - node v6.2.0 - v6.10.0 (v7+ not supported); npm comes with your node installation.
* [xcode](https://developer.apple.com/xcode/) - only required for OS X users
* [nvm](https://github.com/creationix/nvm/blob/master/README.markdown) - if you want to use the nvm install command to retrieve a node version

## Steps
1. [Download Platform-specific Binaries](#1-download-platform-specific-binaries)
2. [Setting up the Network using script](#2-setting-up-the-network-using-script)
3. [Setting up the Network manually](#3-setting-up-the-network-manually)
4. [Troubleshooting](#4-troubleshooting)
5. [Additional Resources](#5-additional-resources)

## 1. Download Platform-specific Binaries

Please execute the following command from within the directory into which you will extract the platform-specific binaries:
```bash
curl -sSL https://goo.gl/iX9dek | bash
```
The curl command above downloads and executes a bash script that will download and extract all of the platform-specific binaries you will need to set up your network and place them into the cloned repo you created above. It retrieves the following four platform-specific binaries and places them in the bin sub-directory of the current working directory.
* cryptogen
* configtxgen
* configtxlator
* peer

You may want to add that to your PATH environment variable so that these can be picked up without fully qualifying the path to each binary. e.g.:
```bash
export PATH=<path to download location>/bin:$PATH
```
Finally, the script will download the Hyperledger Fabric docker images from [Docker Hub](https://hub.docker.com/u/hyperledger/) into your local Docker registry and tag them as ‘latest’.

## 2. Setting up the Network using script

We provide a fully annotated script - `byfn.sh` - that leverages these Docker images to quickly bootstrap a Hyperledger Fabric network comprised of 4 peers representing two different organizations, and an orderer node. It will also launch a container to run a scripted execution that will join peers to a channel, deploy and instantiate chaincode and drive execution of transactions against the deployed chaincode.

Here’s the help text for the `byfn.sh` script:
```bash
./byfn.sh -h
Usage:
  byfn.sh -m up|down|restart|generate [-c <channel name>] [-t <timeout>]
  byfn.sh -h|--help (print this message)
    -m <mode> - one of 'up', 'down', 'restart' or 'generate'
      - 'up' - bring up the network with docker-compose up
      - 'down' - clear the network with docker-compose down
      - 'restart' - restart the network
      - 'generate' - generate required certificates and genesis block
    -c <channel name> - config name to use (defaults to "mychannel")
    -t <timeout> - CLI timeout duration in microseconds (defaults to 10000)

    Typically, one would first generate the required certificates and
    genesis block, then bring up the network. e.g.:

    	byfn.sh -m generate -c <channelname>
    	byfn.sh -m up -c <channelname>
    	byfn.sh -m down -c <channelname>

    Taking all defaults:
    	byfn.sh -m generate
    	byfn.sh -m up
    	byfn.sh -m down
```
### Generate Network Artifacts

This step generates all of the certificates and keys for all our various network entities, the `genesis block` used to bootstrap the ordering service, and a collection of configuration transactions required to configure a [Channel](http://hyperledger-fabric.readthedocs.io/en/latest/glossary.html#channel).

Execute the following command:
```bash
./byfn.sh -m generate
```

You will see a brief description as to what will occur, along with a yes/no command line prompt. Respond with a `y` to execute the described action.

```bash
Generating certs and genesis block for with channel 'mychannel' and CLI timeout of '10000'
Continue (y/n)? y
proceeding ...
/Users/ishan/Documents/git-demo/BlockchainNetwork-CompositeJourney/bin/cryptogen

##########################################################
##### Generate certificates using cryptogen tool #########
##########################################################
org1.example.com
org2.example.com

sed: 1: "s/CA1_PRIVATE_KEY/0a11a ...": unescaped newline inside substitute pattern
sed: 1: "s/CA2_PRIVATE_KEY/798ce ...": unescaped newline inside substitute pattern
rm: docker-compose-e2e.yamlt: No such file or directory
/Users/ishan/Documents/git-demo/BlockchainNetwork-CompositeJourney/bin/configtxgen
##########################################################
#########  Generating Orderer Genesis block ##############
##########################################################
2017-07-19 15:39:56.264 PDT [common/configtx/tool] main -> INFO 001 Loading configuration
2017-07-19 15:39:56.285 PDT [common/configtx/tool] doOutputBlock -> INFO 002 Generating genesis block
2017-07-19 15:39:56.287 PDT [common/configtx/tool] doOutputBlock -> INFO 003 Writing genesis block

#################################################################
### Generating channel configuration transaction 'channel.tx' ###
#################################################################
2017-07-19 15:39:56.304 PDT [common/configtx/tool] main -> INFO 001 Loading configuration
2017-07-19 15:39:56.307 PDT [common/configtx/tool] doOutputChannelCreateTx -> INFO 002 Generating new channel configtx
2017-07-19 15:39:56.307 PDT [common/configtx/tool] doOutputChannelCreateTx -> INFO 003 Writing new channel tx

#################################################################
#######    Generating anchor peer update for Org1MSP   ##########
#################################################################
2017-07-19 15:39:56.328 PDT [common/configtx/tool] main -> INFO 001 Loading configuration
2017-07-19 15:39:56.331 PDT [common/configtx/tool] doOutputAnchorPeersUpdate -> INFO 002 Generating anchor peer update
2017-07-19 15:39:56.331 PDT [common/configtx/tool] doOutputAnchorPeersUpdate -> INFO 003 Writing anchor peer update

#################################################################
#######    Generating anchor peer update for Org2MSP   ##########
#################################################################
2017-07-19 15:39:56.350 PDT [common/configtx/tool] main -> INFO 001 Loading configuration
2017-07-19 15:39:56.354 PDT [common/configtx/tool] doOutputAnchorPeersUpdate -> INFO 002 Generating anchor peer update
2017-07-19 15:39:56.354 PDT [common/configtx/tool] doOutputAnchorPeersUpdate -> INFO 003 Writing anchor peer update
```

### Bring Up the Network

 You can bring the network up with the following command:
 ```bash
 ./byfn.sh -m up
 ```
 Once again, you will be prompted as to whether you wish to continue or abort. Respond with a `y`:
```bash
Starting with channel 'mychannel' and CLI timeout of '10000'
Continue (y/n)?y
proceeding ...
Creating network "net_byfn" with the default driver
Creating peer0.org1.example.com
Creating peer1.org1.example.com
Creating peer0.org2.example.com
Creating orderer.example.com
Creating peer1.org2.example.com
Creating cli


 ____    _____      _      ____    _____
/ ___|  |_   _|    / \    |  _ \  |_   _|
\___ \    | |     / _ \   | |_) |   | |
 ___) |   | |    / ___ \  |  _ <    | |
|____/    |_|   /_/   \_\ |_| \_\   |_|

Channel name : mychannel
Creating channel...
```
The logs will continue from there. This will launch all of the containers, and then drive a complete end-to-end application scenario. Upon successful completion, it should report the following in your terminal window:
```bash
2017-05-16 17:08:01.366 UTC [msp] GetLocalMSP -> DEBU 004 Returning existing local MSP
2017-05-16 17:08:01.366 UTC [msp] GetDefaultSigningIdentity -> DEBU 005 Obtaining default signing identity
2017-05-16 17:08:01.366 UTC [msp/identity] Sign -> DEBU 006 Sign: plaintext: 0AB1070A6708031A0C08F1E3ECC80510...6D7963631A0A0A0571756572790A0161
2017-05-16 17:08:01.367 UTC [msp/identity] Sign -> DEBU 007 Sign: digest: E61DB37F4E8B0D32C9FE10E3936BA9B8CD278FAA1F3320B08712164248285C54
Query Result: 90
2017-05-16 17:08:15.158 UTC [main] main -> INFO 008 Exiting.....
===================== Query on PEER3 on channel 'mychannel' is successful =====================

===================== All GOOD, BYFN execution completed =====================


 _____   _   _   ____
| ____| | \ | | |  _ \
|  _|   |  \| | | | | |
| |___  | |\  | | |_| |
|_____| |_| \_| |____/
```

### Bring Down the Network

Execute the following command to kill your containers, remove the crypto material and four artifacts, and delete the chaincode images from your Docker Registry:
```bash
./byfn.sh -m down
```
Once again, you will be prompted to continue, respond with a `y`:
```bash
Stopping with channel 'mychannel' and CLI timeout of '10000'
Continue (y/n)?y
proceeding ...
WARNING: The CHANNEL_NAME variable is not set. Defaulting to a blank string.
WARNING: The TIMEOUT variable is not set. Defaulting to a blank string.
Removing network net_byfn
468aaa6201ed
...
Untagged: dev-peer1.org2.example.com-mycc-1.0:latest
Deleted: sha256:ed3230614e64e1c83e510c0c282e982d2b06d148b1c498bbdcc429e2b2531e91
...
```

## 3. Setting up the Network manually

### 3.a Crypto Generator

We will use the `cryptogen` tool to generate the cryptographic material (x509 certs) for our various network entities. These certificates are representative of identities, and they allow for sign/verify authentication to take place as our entities communicate and transact.

Cryptogen consumes a file - `crypto-config.yaml` - that contains the network topology and allows us to generate a set of certificates and keys for both the Organizations and the components that belong to those Organizations. Each Organization is provisioned a unique root certificate (`ca-cert`) that binds specific components (peers and orderers) to that Org. By assigning each Organization a unique CA certificate, we are mimicking a typical network where a participating Member would use its own Certificate Authority. Transactions and communications within Hyperledger Fabric are signed by an entity’s private key (`keystore`), and then verified by means of a public key (`signcerts`). `count` variable is used to specify the number of peers per Organization; in our case there are two peers per Org.
Execute the following command to runt he `cryptongen` tool
```bash
./bin/cryptogen generate --config=./crypto-config.yaml
```
You will likely see the following warning. It’s innocuous, ignore it:
```bash
[bccsp] GetDefault -> WARN 001 Before using BCCSP, please call InitFactories(). Falling back to bootBCCSP.
```
After we run the `cryptogen` tool, the generated certificates and keys will be saved to a folder titled `crypto-config`.

You can refer to the [Membership Service Providers (MSP)](http://hyperledger-fabric.readthedocs.io/en/latest/msp.html) documentation for a deeper dive on MSP.

### 3.b Configuration Transaction Generator

The `configtxgen` tool is used to create four configuration artifacts:
* orderer genesis block,
* channel channel configuration transaction,
* and two anchor peer transactions - one for each Peer Org.

The orderer block is the [Genesis Block](http://hyperledger-fabric.readthedocs.io/en/latest/glossary.html#genesis-block) for the ordering service, and the channel transaction file is broadcast to the orderer at [Channel](http://hyperledger-fabric.readthedocs.io/en/latest/glossary.html#channel) creation time. The anchor peer transactions specify each Org’s [Anchor Peer](http://hyperledger-fabric.readthedocs.io/en/latest/glossary.html#anchor-peer) on this channel.

Configtxgen consumes a file - `configtx.yaml` - that contains the definitions for the sample network. There are three members - one Orderer Org (`OrdererOrg`) and two Peer Orgs (`Org1` & `Org2`) each managing and maintaining two peer nodes. This file also specifies a consortium - `SampleConsortium` - consisting of our two Peer Orgs.

The `profile` section of the file contains two unique headers. One for the orderer genesis block - `TwoOrgsOrdererGenesis` - and one for our channel - `TwoOrgsChannel`. This file also contains two additional specifications that are worth noting. Firstly, we specify the anchor peers for each Peer Org (`peer0.org1.example.com` & `peer0.org2.example.com`). Secondly, we point to the location of the MSP directory for each member, in turn allowing us to store the root certificates for each Org in the orderer genesis block. Now any network entity communicating with the ordering service can have its digital signature verified.

First, we need to set an environment variable to specify where `configtxgen` should look for the `configtx.yaml` configuration file:
```bash
export FABRIC_CFG_PATH=$PWD
```
Execute the following command to invoke the `configtxgen` tool to generate the orderer genesis block.
```bash
./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
```
To create the channel transaction artifact, set CHANNEL_NAME as an environment variable that can be used throughout these instructions:
```bash
export CHANNEL_NAME=mychannel
# this file contains the definitions for our sample channel
./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
```
Execute the following command to define the anchor peer for Org1 & Org2 on the channel.
```bash
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
```
You can refer to the [Channel Configuration (configtxgen)](http://hyperledger-fabric.readthedocs.io/en/latest/configtxgen.html) documentation for a complete description of the use of this tool.

### 3.c Start the network

Use the docker-compose script to spin up our network. The docker-compose file references the images that we have previously downloaded, and bootstraps the orderer with our previously generated `genesis.block`.
```bash
working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
# command: /bin/bash -c './scripts/script.sh ${CHANNEL_NAME}; sleep $TIMEOUT'
volumes
```
If left uncommented, script.sh will exercise all of the CLI commands when the network is started, as described in [Behind the scenes - script.sh](#3c5-behind-the-scenes---scriptsh) section. However, we want to go through the commands manually in order to expose the syntax and functionality of each call.

Pass in a moderately high value for the `TIMEOUT` variable (specified in seconds); otherwise the CLI container, by default, will exit after 60 seconds.

Start your network:
```bash
CHANNEL_NAME=$CHANNEL_NAME TIMEOUT=<pick_a_value> docker-compose -f docker-compose-cli.yaml up -d
```
If you want to see the realtime logs for your network, then do not supply the `-d` flag. If you let the logs stream, then you will need to open a second terminal to execute the CLI calls.

#### 3.c.1 Environment variables

For the following CLI commands against `peer0.org1.example.com` to work, we need to preface our commands with the four environment variables given below. These variables for `peer0.org1.example.com` are baked into the CLI container, therefore we can operate without passing them. **HOWEVER**, if you want to send calls to other peers or the orderer, then you will need to provide these values accordingly. Inspect the `docker-compose-base.yaml` for the specific paths:
```bash
# Environment variables for PEER0
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
CORE_PEER_ADDRESS=peer0.org1.example.com:7051
CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
```

#### 3.c.2 Create & Join Channel

We will enter the CLI container using the docker exec command:
```bash
docker exec -it cli bash
```
If successful you should see the following:
```bash
root@3e3a8c54e9fa:/opt/gopath/src/github.com/hyperledger/fabric/peer#
```

Execute the following command to create the channel. We specify our channel name with the `-c` flag, channel configuration transaction with the `-f` flag and `--cafile` flag is the local path to the orderer’s root cert, allowing us to verify the TLS handshake.
```bash
export CHANNEL_NAME=mychannel

# the channel.tx file is mounted in the channel-artifacts directory within your CLI container
# as a result, we pass the full path for the file
# we also pass the path for the orderer ca-cert in order to verify the TLS handshake
# be sure to replace the $CHANNEL_NAME variable appropriately

peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```
Now let’s join `peer0.org1.example.com` to the channel.
```bash
peer channel join -b $CHANNEL_NAME.block
```
You can make other peers join the channel as necessary by making appropriate changes in the four environment variables.

#### 3.c.3 Install & Instantiate Chaincode

Applications interact with the blockchain ledger through `chaincode`. **We need to install the chaincode on every peer that will execute and endorse our transactions, and then instantiate the chaincode on the channel**.

First, install the sample Go code onto one of the four peer nodes. This command places the source code onto our peer’s filesystem.
```bash
peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
```
Execute the folloeing command to initiate the chaincode on the channnel, set the endorsement policy for the chaincode, and launch a chaincode container for the targeted peer. `-P` flag is used to set our policy where we specify the required level of endorsement for a transaction against this chaincode to be validated. In the command below you’ll notice that we specify our policy as `-P "OR ('Org0MSP.member','Org1MSP.member')"`. This means that we need “endorsement” from a peer belonging to Org1 OR Org2 (i.e. only one endorsement). If we changed the syntax to `AND` then we would need two endorsements.
```bash
# be sure to replace the $CHANNEL_NAME environment variable
# if you did not install your chaincode with a name of mycc, then modify that argument as well

peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "OR ('Org1MSP.member','Org2MSP.member')"
```
You can refer to the [endorsement policies](http://hyperledger-fabric.readthedocs.io/en/latest/endorsement-policies.html) documentation for more details on policy implementation.

#### 3.c.4 Query & Invoke chaincode

Let’s query for the value of `a` to make sure the chaincode was properly instantiated and the state DB was populated. The syntax for query is as follows:
```bash
# be sure to set the -C and -n flags appropriately
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
```
Now let’s move `10` from `a`to `b`. This transaction will cut a new block and update the state DB. The syntax for invoke is as follows:
```bash
# be sure to set the -C and -n flags appropriately

peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem  -C $CHANNEL_NAME -n mycc -c '{"Args":["invoke","a","b","10"]}'
```
Let’s confirm that our previous invocation executed properly. We initialized the key `a` with a value of `100` and just removed `10` with our previous invocation. Therefore, a query against a should reveal `90`. The syntax for query is as follows.
```bash
# be sure to set the -C and -n flags appropriately

peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
```

#### 3.c.5 Behind the scenes - script.sh

These steps describe the scenario in which `script.sh` is not commented out in the `docker-compose-cli.yaml` file. Clean your network with `./byfn.sh -m down` and ensure this command is active. Then use the same docker-compose prompt to launch your network again.
* A script - `script.sh` - is baked inside the CLI container. The script drives the `createChannel` command against the supplied channel name and uses the channel.tx file for channel configuration.
* The output of `createChannel` is a genesis block - `<your_channel_name>.block` - which gets stored on the peers’ file systems and contains the channel configuration specified from channel.tx.
* The `joinChannel` command is exercised for all four peers, which takes as input the previously generated genesis block. This command instructs the peers to join `<your_channel_name>` and create a chain starting with `<your_channel_name>`.block.
* Now we have a channel consisting of four peers, and two organizations. This is our `TwoOrgsChannel` profile.
* `peer0.org1.example.com` and `peer1.org1.example.com` belong to Org1; `peer0.org2.example.com` and `peer1.org2.example.com belong` to Org2
* These relationships are defined through the `crypto-config.yaml` and the MSP path is specified in our docker compose.
The anchor peers for Org1MSP (`peer0.org1.example.com`) and Org2MSP (`peer0.org2.example.com`) are then updated. We do this by passing the `Org1MSPanchors.tx` and `Org2MSPanchors.tx` artifacts to the ordering service along with the name of our channel.
* A chaincode - **chaincode_example02** - is installed on `peer0.org1.example.com` and `peer0.org2.example.com`
* The chaincode is then “instantiated” on `peer0.org2.example.com`. Instantiation adds the chaincode to the channel, starts the container for the target peer, and initializes the key value pairs associated with the chaincode. The initial values for this example are [“a”,”100” “b”,”200”]. This “instantiation” results in a container by the name of dev-peer0.org2.example.com-mycc-1.0 starting.
* The instantiation also passes in an argument for the endorsement policy. The policy is defined as `-P "OR    ('Org1MSP.member','Org2MSP.member')"`, meaning that any transaction must be endorsed by a peer tied to Org1 or Org2.
* A query against the value of “a” is issued to `peer0.org1.example.com`. The chaincode was previously installed on `peer0.org1.example.com`, so this will start a container for Org1 peer0 by the name of `dev-peer0.org1.example.com-mycc-1.0`. The result of the query is also returned. No write operations have occurred, so a query against “a” will still return a value of “100”.
* An invoke is sent to `peer0.org1.example.com` to move “10” from “a” to “b”
* The chaincode is then installed on `peer1.org2.example.com`
* A query is sent to `peer1.org2.example.com` for the value of “a”. This starts a third chaincode container by the name of `dev-peer1.org2.example.com-mycc-1.0`. A value of 90 is returned, correctly reflecting the previous transaction during which the value for key “a” was modified by 10.

Chaincode **MUST** be installed on a peer in order for it to successfully perform read/write operations against the ledger. Furthermore, a chaincode container is not started for a peer until an `init`or traditional transaction - read/write - is performed against that chaincode (e.g. query for the value of “a”). The transaction causes the container to start. Also, all peers in a channel maintain an exact copy of the ledger which comprises the blockchain to store the immutable, sequenced record in blocks, as well as a state database to maintain a snapshot of the current state. This includes those peers that do not have chaincode installed on them (like `peer1.org1.example.com` in the above example) . Finally, the chaincode is accessible after it is installed (like `peer1.org2.example.com` in the above example) because it has already been instantiated.

#### 3.c.5 View transaction and chaincode logs

Execute the following command to view the logs for the CLI Docker container.
```bash
docker logs -f cli
```
Inspect the individual chaincode containers to see the separate transactions executed against each container. Here is the combined output from each container:
```bash
docker logs dev-peer0.org2.example.com-mycc-1.0
04:30:45.947 [BCCSP_FACTORY] DEBU : Initialize BCCSP [SW]
ex02 Init
Aval = 100, Bval = 200

$ docker logs dev-peer0.org1.example.com-mycc-1.0
04:31:10.569 [BCCSP_FACTORY] DEBU : Initialize BCCSP [SW]
ex02 Invoke
Query Response:{"Name":"a","Amount":"100"}
ex02 Invoke
Aval = 90, Bval = 210

$ docker logs dev-peer1.org2.example.com-mycc-1.0
04:31:30.420 [BCCSP_FACTORY] DEBU : Initialize BCCSP [SW]
ex02 Invoke
Query Response:{"Name":"a","Amount":"90"}
```

## 4. Troubleshooting
* Always start your network fresh. Use the following command to remove artifacts, crypto, containers and chaincode images:
```bash
./byfn.sh -m down
```
* You will see errors if you do not remove the containers and images
* If you see Docker errors, first check your version (should be 17.03.1 or above), and then try restarting your Docker process. Problems with Docker are oftentimes not immediately recognizable. For example, you may see errors resulting from an inability to access crypto material mounted within a container.
* If they persist remove your images and start from scratch:
```bash
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -q)
```
* If you see errors on your create, instantiate, invoke or query commands, make sure you have properly updated the channel name and chaincode name. There are placeholder values in the supplied sample commands.
* If you see the below error:
```bash
Error: Error endorsing chaincode: rpc error: code = 2 desc = Error installing chaincode code mycc:1.0(chaincode /var/hyperledger/production/chaincodes/mycc.1.0 exits)
```
You likely have chaincode images (e.g. `dev-peer1.org2.example.com-mycc-1.0` or `dev-peer0.org1.example.com-mycc-1.0`) from prior runs. Remove them and try again.
```bash
docker rmi -f $(docker images | grep peer[0-9]-peer[0-9] | awk '{print $3}')
```
* If you see something similar to the following:
```bash
Error connecting: rpc error: code = 14 desc = grpc: RPC failed fast due to transport failure
Error: rpc error: code = 14 desc = grpc: RPC failed fast due to transport failure
```
Make sure you are running your network against the **1.0.0** images that have been retagged as **latest**.
* If you see the below error:
```bash
[configtx/tool/localconfig] Load -> CRIT 002 Error reading configuration: Unsupported Config Type ""
panic: Error reading configuration: Unsupported Config Type ""
```
Then you did not set the `FABRIC_CFG_PATH` environment variable properly. The `configtxgen` tool needs this variable in order to locate the `configtx.yaml`. Go back and execute an `export FABRIC_CFG_PATH=$PWD`, then recreate your channel artifacts.
* To cleanup the network, use the down option:
```bash
./byfn.sh -m down
```
* If you see an error stating that you still have **active endpoints**, then prune your Docker networks. This will wipe your previous networks and start you with a fresh environment:
```bash
docker network prune
```
* You will see the following message:
```bash
WARNING! This will remove all networks not used by at least one container.
Are you sure you want to continue? [y/N]
```
Select `y`.
* If you continue to see errors, share your logs on the **# fabric-questions channel** on [Hyperledger Rocket Chat](https://chat.hyperledger.org/home).

## 5. Additional Resources
* [Hyperledger Fabric Docs](http://hyperledger-fabric.readthedocs.io/en/latest/)

## License
[Apache 2.0](LICENSE)
