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









