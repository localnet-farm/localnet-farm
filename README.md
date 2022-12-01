Localnet.Farm
===

A place for your hosted Filecoin Lotus localnets!

## Overview

A "localnet" is often used by Filecoin Lotus developers to run a small-scale network separate from the mainnet to test code or simulate scenarios.

* [Manual Localnet setup instructions](https://lotus.filecoin.io/lotus/developers/local-network/)

Jim Pick created a set of Docker images with a Lotus localnet targeting the FVM development branch.

* https://github.com/jimpick/lotus-fvm-localnet

These images have been used together with Kubernetes and Knative to power the ["FVM Actor Code Playground"](https://observablehq.com/collection/@jimpick/filecoin-virtual-machine) notebooks on ObservableHQ. When the notebooks are accessed, an on-demand localnet is spun up on a Kubernetes cluster. After a period of inactivity, the clusters are destroyed. As the state in the localnet is ephemeral, this is ideal for demos and experimentation. As the localnets don't consume resources when not in use, it is feasible to keep old builds of the software around, so demos referencing old builds will keep working, even as breaking changes occur.

The "Localnet.Farm" project will take these images, and deploy them on AWS, so multiple localnets can be run at once. Teams will be able to deploy and control their own instances in a multi-tenant environment, with individual control over the localnet configuration, software versions, persistance, etc.

## Roadmap

* https://www.starmaps.app/roadmap/github.com/jimpick/localnet-farm/issues/4

## Prototypes

A series of cluster setups can be found in the prototypes directory. As newer clusters are deployed to support newer milestones, older cluster instances will be sunsetted.

* https://github.com/jimpick/localnet-farm/tree/main/prototypes

## Contact Info

Send a message to `@Jim Pick` on the Filecoin Slack for more info.

## License

Apache 2 or MIT
