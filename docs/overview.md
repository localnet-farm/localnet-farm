# What is Localnet.Farm?

If you are developing applications for Filecoin or working
on the platform itself, this might be a useful tool.

[Localnet.Farm](https://localnet.farm/) lets you run "on-demand localnets in the cloud".

# So, what is a localnet? And why would you use one?

In our case, what we are calling a [localnet](https://lotus.filecoin.io/lotus/developers/local-network/)
is a small isolated instance of the Filecoin blockchain that you run locally. It is bootstrapped from
scratch, and you have full control over it.

That means:

  * you are free to run pre-release code and modify any part of it
  * you can reset it at any time
  * it doesn't use real funds - you can mint your own tokens
  * you have control over all the "miners" on the localnet, so
    you can simulate any scenario
      * you can store data with them
      * you can simulate failures and faults
      * you can experiment with economics
  * the localnet usually configured to have a small sector size,
    and it is configured to run fast with low security so you
    don't have to wait a long time to see the results of your
    transactions

# How is is different from the "mainnet"?

In contrast, the main Filecoin network, called "mainnet":

  * https://filecoin.io/
  * runs on thousands of machines around the world
  * only runs thoroughly tested software that has been through
    a rigourous test and release cycle lasting months or years
  * can't be reset
  * uses the FIL token, which you have to get somehow, usually
    by purchasing it with real money
  * has strong security requirements, large sector sizes (32GiB or 64GiB),
    and it only generates new blocks every 30 seconds

# How is is different from a "testnet"?

In addition to mainnet, the Filecoin project also runs a number
of [developer "testnets"](https://github.com/filecoin-project/FIPs/discussions/544).

These are:

  * independent of mainnet
  * they have a small number of miners
  * are usually a shared resource used by multiple groups of developers
  * they are often running pre-release or experimental code that might
    eventually make it to mainnet after development and testing is complete
  * they are sometimes reset or upgraded
  * they don't use real funds, but as they are a shared resource, they
    typically have a "faucet" for retrieving tokens, which has rate limits
    to prevent abuse
  * they often have lower security and sector sizes to make it easier
    to participate in

Additionally, for developers building smart contracts, there are tools from
the Ethereum ecosystem, such as Remix, Hardhat, Ganache or Foundry that let you
run your smart contracts locally on a simulated blockchain. These tools have
really great debugging support, as well as the ability to do things like
snapshots. They do not currently have support for Filecoin specific
APIs.

  * https://remix-project.org/
  * https://hardhat.org/
  * https://trufflesuite.com/ganache/
  * https://getfoundry.sh/

# Setting up a localnet "from scratch" on your own machine

In order to better understand the parts of a localnet, let's quickly list
the steps involved in running one manually on your own developer machine:

* https://lotus.filecoin.io/lotus/developers/local-network/

1. Install pre-requisites (Linux or MacOS)
2. Set up a Lotus node
   a. Set environment variables
   b. Checkout code
   c. `make 2k`
   d. Fetch parameters for 2048-byte sectors
   e. Preseal 2 sectors
   f. Create the genesis block
   g. Create a pre-miner and an address with some funds
3. Start the node and miner
   a. Start the first node
   b. Import genesis miner key
   c. Init the genesis miner
   d. Start the genesis miner

The documentation lists additional steps if you want to use Fil+ on the localnet
or set additional nodes or miners.

Compiling from scratch is a great way to run a localnet, as it gives you the
maximum amount of control over the environment. However, it has some downsides:

* it consumes resources on your local machine
* setting up dependencies can be time consuming
* you can't use Windows natively (but you could use Linux in a virtual machine)
* there are a lot of environment variables and multiple daemons to manage
* it's hard to remember all the steps
* to collaborate with other people, they will need to have network access to
  the machine where the localnet is installed

# Setting up a localnet using pre-built Docker images

It can be complicated to set up a localnet "from scratch" to run locally. One
approach to reduce the number of setup steps is to use pre-built Docker
images.

An example of this technique can be found here:

* https://github.com/jimpick/lotus-fvm-localnet

That GitHub repo is used to build a set of Docker images for a specific branch
of Lotus with pre-release FVM support.

If you are interested in running that particular branch, then you can use
desktop Docker or Kubernetes or any other container runtime to quickly spin
up a localnet. Instructions can be found in the README file for using the
container images with Docker or Kubernetes.

Creating a localnet this way has most of the same advantages and disadvantages
as the "from scratch" method.

As the images are pre-built, it is not necessary for developers to install
dependencies required to build the images. This means that if you are
developing on Windows, you can still run a localnet inside Docker even though
building natively is not supported.

The largest disadvantage of using the Docker images is that you are restricted
to the images that have been pre-built. If you want to run Lotus from a
different branch or commit, you will need to build new images.

The jimpick/lotus-fvm-localnet repo has a fully automated build system using
GitHub Actions and the GitHub Container Registry to make it fairly easy to
build new images. The "lotus" source code is checked into the repo using git
submodules. Simple updating the submodule and pushing new code to GitHub
should result in new container images being built automatically. Because the
build process is very long, it is broken into a number of stages. Once all
the stages have completed building, the resulting Docker container image
can be fetched directly from GitHub using the digest hash or 'latest' tag.

# Localnet.Farm Introduction

Running a localnet on your own developer machine consumes resources, and
is difficult to share with other developers. Because local development
hardware resources are usually limited, it can be difficult to keep
multiple localnets available at the same time.

Localnet.Farm is a service that lets you run your localnets in the cloud
using Docker container images.

When you run your localnet on Localnet.Farm, it runs on a particular
Kubernetes cluster running on a cloud provider (currently Amazon Web Services).

Because it runs in the cloud, it is possible to run a multi-tenant service,
where each tenant can have their own hardware resources for their localnet.

It is also possible for multiple developers to share a localnet.

Each localnet gets an https endpoint which can be used to interact with
all of the nodes, miners and other services in localnet.

The portal at Localnet.Farm is just a link to the GitHub project at:

  * https://github.com/jimpick/localnet-farm

In that repo, you can find the core documentation as well as the scripts and
Kubernetes resources used to setup the clusters and provision the workloads
(the localnets).

## Localnet.Farm clusters and endpoints

There are some localnets provisioned for multiple users to "share".

There are also additional localnets allocated to individuals or teams who
would like to work with isolated localnets that they can customize and
reset when they need to. In the future, we may even support snapshots.

We are using a Kubernetes technology called "Knative" in the clusters which
will "spin up" the localnets on demand, and then "spin down" the localnets
after a configurable period of inactivity. This is great because that means
we can configure lots and lots of endpoints, but they only consume resources
when they are in use.

We can provision endpoints for specific releases or builds of the Lotus
software, and leave them available far into the future, as they don't
consume resources when not in-use. This is great for demos and testing.
A demo or test can refer to an endpoint that is bound to a specific
build, and that endpoint can stay alive for a long time, even as newer
releases come out that are no longer compatible for the demo/test.

At this point in time, the project is being actively developed. Protocol Labs
is supporting the project with a grant and they are also
subsidizing running the clusters on AWS.

Custom endpoints are available by request (just file a GitHub issue). It is
inexpensive to create multiple endpoints as they don't consume resources
when not in use.

## "Shared" endpoint tour

Let's look at an available localnet provisioned on the system.

This particular localnet is intended for "shared" usage. It is built against a specific pre-release of Lotus with FVM support (the Carbonado.1 Patch 1 build). The localnet has a single node, a single miner, and a reverse proxy container.

The Kubernetes resource that configures the Docker images is here:

* https://github.com/jimpick/localnet-farm/blob/main/prototypes/localnet-farm-3/argocd-workloads/shared/fvm-hyperspace-latest-quick.yaml

This YAML file gets loaded into the Kubernetes cluster we have set up on AWS named "localnet-farm-3".

Because it describes a Knative service, when it is loaded, an https endpoint will appear at:

* https://shared-fvm-hyperspace-latest.quick.cluster-3.localnet.farm

The endpoint is named after the service name in the resource file ("shared-fvm-hyperspace-latest") and the namespace ("quick").

We are using naming conventions to identify and organize all the endpoints.

The "shared-" part of the name means that this particular endpoint is a public endpoint that multiple developers can share. If instead a developer or team needs an isolated localnet instance, it might be referred to using a unique identifier, like their GitHub account name, eg. "jimpick-".

The "-fvm-hyperspace-latest" part of the name refers to a specific set of Docker images. In this case, these images were build with pre-release FVM support from the Carbonado.1 Patch 1 release tag. Endpoints that include a particular release name can be kept around for a long time, which is useful for things like demos that you don't want to break when new releases come out.

Alternatively, an endpoint could be created with a generic release name, eg. "-fvm-latest". Any applications using that endpoint would automatically connect to the latest code deployed there.

In the YAML file above, there is a "node" and a "miner-1" container. These refer to images that were published to the GitHub Container Registry. Check out this repo to see how the images were built:

* https://github.com/jimpick/lotus-fvm-localnet

We're using the Docker container digest hash to refer to the images so we can get a specific image. We could also refer to "@latest" or another tag in the container registry if we wanted to.

Additionally, there is a special container named "gateway" that contains the reverse proxy. We are using Knative, which lets us expose a single web service endpoint at the https URL. The "gateway" contains a reverse proxy web service which can be used to multiplex the internal node and miner APIs and anything else from the localnet and make it available to the internet-facing endpoint. It also does additional work like adding CORS headers so the APIs can be accessed from web applications.

In this example, it is a simple configuration where we are only exposing the JSON-RPC API on the node. We are also making available the token with admin privileges for the Lotus node, including access to the wallet with the genesis actor funds. This is necessary for most applications to get initial funds (there is no faucet).

The code for the "gateway" (not be be confused with lotus-gateway) for this example can be found here:

* https://github.com/jimpick/localnet-farm-gateway

It uses the Caddy web server to implement the reverse proxy and to serve the token file. Different localnet configurations may require a different gateway image with additional customizations.

To "spin up" the localnet, simply make a web request to the endpoint. Localnet endpoints in the "quick" namespace are configured to run on a Kubernetes node that is already provisioned, so the "pod" with the containers gets started fairly quickly (less than 30 seconds). The Lotus Docker images contain a pre-initialized blockchain, so once started, it should be mining new blocks in less than a minute.

The Lotus node [JSON-RPC API](https://lotus.filecoin.io/reference/basics/overview/) for this example can be accessed using curl (plus jq for pretty-printing):

```
curl -X POST \
    'https://shared-fvm-hyperspace-latest.quick.cluster-3.localnet.farm/rpc/v0' \
    --header "Content-Type: application/json" \
    --data @- << EOF | jq
{
  "jsonrpc": "2.0",
  "method": "Filecoin.ChainHead",
  "params": [],
  "id": 1
}
EOF
```

Example output:

```
{
  "jsonrpc": "2.0",
  "result": {
    "Cids": [
      {
        "/": "bafy2bzaceaopub3p7kduksvbpz4k2xtc4bsb7m7op5zkzt2ehmnk3pkb7ppza"
      }
    ],
    "Blocks": [
      {
        "Miner": "t01000",
        "Ticket": {
          "VRFProof": "tcyL+b3fUxlucpuh6g/vGl6c6N/1cXANMTMlQZkS4zSFunSrYetaZ/VJNLv1tg/sCvHTU454d0gqxay0N34iP084In2yPl+D9AgoCqBUMv3fFBHX0FJnkaIYPsFgNwMG"
        },
        "ElectionProof": {
          "WinCount": 2,
          "VRFProof": "rxoqF2va6v2WbHXTSIT2OYL/kiEW1yHhRiobrvofKA0YbimK4+S8xaj+/j0y8RFzAC5bkkGKFEny1b0YDMF4xwhzMFhbpV3kEqPDmzJWktncKBQ5BUBeAnSqoyRKMVZz"
        },
        "BeaconEntries": [
          {
            "Round": 2596008,
            "Data": "hu839V1EYEdNW2hHduJaw+PSCcvlRloU9vGeRkmRNLPJLRbtU6hMb4Y8dhQ89VkGC5hRD19rWKkJ/uMKmMFMU73P9yXL5yDcuHiY1AGl8XfPV10MmYzw3IYKV+k23cDt"
          }
        ],
        "WinPoStProof": [
          {
            "PoStProof": 0,
            "ProofBytes": "qvDMAAsVfUjoaVOwivt9JAgGO69CgOMCDTwPZKwe/mk9SqZ3kPhBZT/wAiXx/bEZoeT8eC2eRVP7TvfLmoFbPhmhbxQcLSj2zkE6SvtGZpH5tGuGHc4JKpe2zGDuI355ASwF9e/QN6icZAmFSd4mFi9UCZ3l/Nx9KzblmLdPwqAJsD6K6afuMUc3MLf4sYQSj8+ED0jkWJxpmMtfke5Vt5XB/gjOH0XLOcFvqI1wYNc/4MxPxM4HnLiTu1Vrn0vi"
          }
        ],
        "Parents": [
          {
            "/": "bafy2bzacec2rrsehl4nwifqyb64vktlmgaoi6mao4l5kvgqkupmke7en3rb5s"
          }
        ],
        "ParentWeight": "111744",
        "Height": 21,
        "ParentStateRoot": {
          "/": "bafy2bzacebr3s5oesgv5z5yudkasgarzmjchbfnowjyra6hhigqknegtmuu7e"
        },
        "ParentMessageReceipts": {
          "/": "bafy2bzacedswlcz5ddgqnyo3sak3jmhmkxashisnlpq6ujgyhe4mlobzpnhs6"
        },
        "Messages": {
          "/": "bafy2bzacecmda75ovposbdateg7eyhwij65zklgyijgcjwynlklmqazpwlhba"
        },
        "BLSAggregate": {
          "Type": 2,
          "Data": "wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        },
        "Timestamp": 1673311265,
        "BlockSig": {
          "Type": 2,
          "Data": "rrsW2rUOckBTOsITJgjFfRSN8cs/UCTIGbbC1n+WYhIIDKMzlvnfKEN3PRnNBrPWAe5O8BTIUJUPyyCN0ykMAQphfH/YLSIPNgJqHSDfBiJfaE7mhct/m419xqMea3fT"
        },
        "ForkSignaling": 0,
        "ParentBaseFee": "6923132"
      }
    ],
    "Height": 21
  },
  "id": 1
}
```

The first time you run this when the localnet has been suspended, you may get an empty response. Accessing the endpoint will cause the localnet to start up.

When the localnet is first starting from a cold start, the "Height" will be 7, but it will start increasing after the miner finishing initializing, which takes a little while. Try running the curl script multiple times until it the "Height" starts to increment.

The gateway container also makes available the token necessary to make
priviledged API calls to the Lotus node. It can be fetched from the `/token` route on the endpoint. This is particular useful for
accessing the Lotus wallet API so funds can be transferred out of the
genesis address.

```
$ curl https://shared-fvm-hyperspace-latest.quick.cluster-3.localnet.farm/token; echo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.9icsCJ4GhHF_HCwrJxetiDgeNrfMhW_gkcIvIUo5dGc
```

Note that there is no security at all! Any application can fetch this token and do anything they want on the node. This approach is optimal for simple demos and testing, but it can be abused. If you need a bit more access control, an alternative gateway Docker image could implement that.

## Foundry tutorial

Let's deploy a simple smart contract to the localnet!

We're going to use [Foundry](https://book.getfoundry.sh/), so the first step is to install it:

* https://getfoundry.sh/

Next, we'll create the `hello_foundry` project following the tutorial:

* https://book.getfoundry.sh/getting-started/first-steps

Here are the commands from the tutorial:

```
forge init hello_foundry
cd hello_foundry
forge build
forge test
```

If that went well, we'll have a simple smart contract ready to deploy to the localnet.

In order to deploy it, we'll need a private key for an Ethereum address. Initially, when the localnet starts up, there is only an address for the "genesis actor" with funds.

We can generate an Ethereum private key using the [filecoin-address-tool](https://github.com/jimpick/filecoin-address-tool) utility (needs Node.js). We'll store it in the PRIVATE_KEY environment variable:

```
PRIVATE_KEY=$(npx filecoin-address-tool generate-random-eth-private-key)
```

Example output:

```
$ echo $PRIVATE_KEY
ecec429285d98762180b17ac2750f2ee688ee88c3dd700072576aca6d7414b64
```

We'll need to transfer funds to it. First, let's get the associated Ethereum address for our private key, and store it in the ETH_ADDRESS environment variable:

```
ETH_ADDRESS=$(npx filecoin-address-tool eth-address-from-eth-private-key $PRIVATE_KEY)
```

Example output:

```
$ echo $ETH_ADDRESS
B746aDF01c73C6cd333590b346214B872ec47cFD
```

Now we can get the [delegated address](https://github.com/filecoin-project/FIPs/blob/master/FIPS/fip-0048.md) (using the f4 address class, but it's a t4 address in this case, because this is a type of testnet). We'll store it in the T4_ADDRESS environment variable:

```
T4_ADDRESS=$(npx filecoin-address-tool delegate-address-from-eth-address --testnet $ETH_ADDRESS)
```

Example output:

```
$ echo $T4_ADDRESS
t410fw5dk34a4opdm2mzvsczumiklq4xmi7h5gjepvpa
```

We'll need write access to the Lotus JSON-RPC API for the next steps. Let's get
the token, and store it in the TOKEN environment variable:

```
TOKEN=$(curl -s https://shared-fvm-hyperspace-latest.quick.cluster-3.localnet.farm/token)
```

Example output:

```
$ echo $TOKEN
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.j4q3Kt3joelJ6dv5u--pO6hu5cmTYPAwDfgHBbAgRco
```

Let's use the Lotus JSON-RPC API to get the default address in the Lotus wallet, which should be the genesis address, and store it in the GENESIS_ADDRESS environment variable:

```
GENESIS_ADDRESS=$(curl -s -X POST \
    'https://shared-fvm-hyperspace-latest.quick.cluster-3.localnet.farm/rpc/v0' \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $TOKEN" \
    --data @- << EOF | jq -r .result
{
  "jsonrpc": "2.0",
  "method": "Filecoin.WalletDefaultAddress",
  "params": [],
  "id": 1
}
EOF
)
```

Example output:

```
$ echo $GENESIS_ADDRESS
t3wnq437pa35rq5mkmqi73dhxru6i3bwilsbqjchaiz272tytlpturmbvzn3zfscrpf5cwipyniuga6u7zvzzq
```

Here is the [Lotus JSON-RPC API documentation](https://lotus.filecoin.io/reference/basics/overview/).

Let's transfer 100 test FIL tokens to our t4 address.

```
curl -s -X POST \
    'https://shared-fvm-hyperspace-latest.quick.cluster-3.localnet.farm/rpc/v0' \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $TOKEN" \
    --data @- << EOF | jq
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "Filecoin.MpoolPushMessage",
  "params": [
    {
      "Version": 0,
      "To": "$T4_ADDRESS",
      "From": "$GENESIS_ADDRESS",
      "Nonce":0,
      "Value":"100000000000000000000",
      "GasLimit":4000000,
      "GasFeeCap":"30000000",
      "GasPremium":"200000",
      "Method":0,
      "Params":null
    },
    null
  ]
}
EOF
```

It will take some time to execute. Wait a minute, and then check the balance on the t4 address:

```
curl -s -X POST \
    'https://shared-fvm-hyperspace-latest.quick.cluster-3.localnet.farm/rpc/v0' \
    --header "Content-Type: application/json" \
    --data @- << EOF | jq
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "Filecoin.StateGetActor",
  "params": [
    "$T4_ADDRESS",
    null
  ]
}
EOF
```

If you see 'actor not found', then message hasn't executed yet. Wait a bit and try again.

The result should look like this if the transfer succeeded:

```
{
  "jsonrpc": "2.0",
  "result": {
    "Code": {
      "/": "bafk2bzacecrloi3xb6bwxsiwtl2chxlgisv5742nkcksahcax3fkrso5wiqrk"
    },
    "Head": {
      "/": "bafy2bzacebc3bt6cedhoyw34drrmjvazhu4oj25er2ebk4u445pzycvq4ta4a"
    },
    "Nonce": 0,
    "Balance": "100000000000000000000",
    "Address": "t410fw5dk34a4opdm2mzvsczumiklq4xmi7h5gjepvpa"
  },
  "id": 1
}
```

The address has a balance, so we can go back to using Foundry to
deploy our smart contract.

```
forge create \
  --rpc-url https://shared-fvm-hyperspace-latest.quick.cluster-3.localnet.farm/rpc/v0 \
  --private-key $PRIVATE_KEY \
  src/Counter.sol:Counter
```

**Oh no!** This fails for some reason ... we need to investigate.

(to be continued...)

## Hardhat

Until forge is working, let's try this instead: https://github.com/filecoin-project/fevm-hardhat-kit

hardhat.config.js:

```
require("@nomicfoundation/hardhat-toolbox")
require("hardhat-deploy")
require("hardhat-deploy-ethers")
require("./tasks")
require("dotenv").config()

const PRIVATE_KEY = process.env.PRIVATE_KEY
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.17",
    defaultNetwork: "localnetFarm",
    networks: {
        localnetFarm: {
            chainId: 31415926,
            url: "https://shared-fvm-hyperspace-latest.quick.cluster-3.localnet.farm/rpc/v1",
            accounts: [ "a336dabf5a760ebb7ccb6aecb07160ae42387131de9aea1876917c309410380a" ],
        },
    },
    paths: {
        sources: "./contracts",
        tests: "./test",
        cache: "./cache",
        artifacts: "./artifacts",
    },
}
```

Set the private key in `accounts:` to whatever $PRIVATE_KEY is.

The f4address returned by `yarn hardhat get-address` should match $T4_ADDRESS.

helper-hardhat-config.js:

```
const { ethers } = require("hardhat")

const networkConfig = {
    31415926: {
        name: "localnetFarm",
        tokenToBeMinted: 12000,
    },
}

// const developmentChains = ["hardhat", "localhost"]

module.exports = {
    networkConfig,
    // developmentChains,
}
```

Example deploy:

```
$ yarn hardhat deploy
You are using a version of Node.js that is not supported by Hardhat, and it may work incorrectly, or not work at all.

Please, make sure you are using a supported version of Node.js.

To learn more about which versions of Node.js are supported go to https://hardhat.org/nodejs-versions
You have both ethereum-waffle and @nomicfoundation/hardhat-chai-matchers installed. They don't work correctly together, so please make sure you only use one.

We recommend you migrate to @nomicfoundation/hardhat-chai-matchers. Learn how to do it here: https://hardhat.org/migrate-from-waffle
Nothing to compile
Wallet Ethereum Address: 0x7eE760129f3d3F210Afee44041F2CcB33f220eec
deploying SimpleCoin...
deploying "SimpleCoin" (tx: 0xaba0eeec3ecbbae5bcb081a5eef45c2c64952c9a2e5bf2a727d447da0e30d2ee)...: deployed at 0x4b5eaaf221c103B1fc6b2207f1cfF7C1ed0FA85E with 12286696 gas
deploying MockMinerAPI...
deploying "MockMinerAPI" (tx: 0xfa66c8f084da1bbaf9ae998c966b983a119dca780fa752264963071f4c127e9c)...: deployed at 0x8c426B59DDB0155B5460dA2625090aecfaBc8842 with 25987066 gas
deploying MockMarketAPI...
deploying "MockMarketAPI" (tx: 0x36350a23188827fbe7a0a56d4b87f286bbc35ac277c7899fd145e2223f589618)...: deployed at 0xB448b765F4dFa6E4eBbD6b8D07C2a1b7C5Ade02c with 45084839 gas
Deploying FilecoinMarketConsumer...
deploying "FilecoinMarketConsumer" (tx: 0xc03323ffa88aa10571efde82877a4caa0c126a99b39014d31b38dad0ca029abf)...: deployed at 0x5505CCADaf0eb22e40a2ef98dFa7A926Ee2e5D1A with 48003858 gas
```

Retrieve balance:

```
$ yarn hardhat get-balance --contract 0x4b5eaaf221c103B1fc6b2207f1cfF7C1ed0FA85E --account $ETH_ADDRESS
You are using a version of Node.js that is not supported by Hardhat, and it may work incorrectly, or not work at all.

Please, make sure you are using a supported version of Node.js.

To learn more about which versions of Node.js are supported go to https://hardhat.org/nodejs-versions
You have both ethereum-waffle and @nomicfoundation/hardhat-chai-matchers installed. They don't work correctly together, so please make sure you only use one.

We recommend you migrate to @nomicfoundation/hardhat-chai-matchers. Learn how to do it here: https://hardhat.org/migrate-from-waffle
Reading SimpleCoin owned by 7eE760129f3d3F210Afee44041F2CcB33f220eec  on network  localnetFarm
Data is:  12000
Total amount of Minted tokens is 12000
```


## Requesting custom endpoints

For now, just file a GitHub issue and we'll set one up for you.

Feel free to contact me at @Jim Pick on the Filecoin Slack.



