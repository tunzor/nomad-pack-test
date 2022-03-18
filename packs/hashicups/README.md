# Hashicups

This version of HashiCups is meant to run on a Nomad cluster without the use of Consul for service discovery.

## Prerequisites

- Nomad cluster
- Ability to access Nomad client on port 80 (with proper security group access, etc.)

## Install 

```
nomad-pack registry add tunzor https://github.com/tunzor/nomad-pack-test.git --target=hashicups
nomad-pack run hashicups --registry=tunzor --ref=latest
```