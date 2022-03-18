Extended from [carljavier/nomad-pack-registry](https://github.com/carljavier/nomad-pack-registry)

# Hashicups

Hashicorp Demo Application to demonstrate various workflows and techniques.

## Install 

```
nomad-pack registry add tunzor https://github.com/tunzor/nomad-pack-test.git --target=hashicups
nomad-pack run hashicups --registry=tunzor --ref=latest
```