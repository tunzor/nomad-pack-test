Extended from [github.com/carljavier/nomad-pack-registry](github.com/carljavier/nomad-pack-registry)

# Hashicups

Hashicorp Demo Application to demonstrate various workflows and techniques.


## Pre-requsites
- Consul service registration and Consul Connect being used with Nomad

## Install 

```
nomad-pack registry add carljavier github.com/carljavier/nomad-pack-registry --target=hashicups
nomad-pack run hashicups --registry=carljavier --ref=latest
```

## Provide the address of the public_api endpoint

To provide the address of the public-api endpoint, change the "public_api_address" variable when running the pack.

```
nomad-pack run hashicups --var public_api_address="[1.1.1.1 OR public-api.example.com]"
```

This tells Nomad Pack to provide `NEXT_PUBLIC_PUBLIC_API_URL` environment variable that the frontend service queries from.
A change was made to the frontend container which makes the call to public-api now a client side request (eg browser) instead of a service side request. 

## Consul Service and Intentions
Optionally, it can configure a Consul service.

If the `register_consul_service` is unset or set to true, the Consul service will be registered.

Several load balancers in the [The Nomad Pack Community Registry](../README.md) are configured to connect to this service by default.

The [NginX](../nginx/README.md) and [HAProxy](../haproxy/README.md) packs are configured to balance the Consul service "hello-world-service", which is th default value for the "consul_service_name" variable.

The [Fabio](../fabio/README.md) and [Traefik](../traefik/README.md) packs are configured to search for Consul services with the tags found in the default value of the "consul_service_tags" variable.

## Variables

- `public_api_address` (string) - Public API Address of the public-api service
- `job_name` (string) - The name to use as the job name which overrides using the pack name
- `datacenters` (list of strings) - A list of datacenters in the region which are eligible for task placement
- `region` (string) - The region where jobs will be deployed
- `register_consul_service` (bool) - If you want to register a consul service for the job. Default true
- `consul_service_tags` (list of string) - The consul service name for the hello-world application
- `consul_service_name` (string) - The consul service name for the hello-world application
- `frontend_version` (string) - Docker image tag
- `public_api_version` (string) - Docker image tag
- `payments_version` (string) - Docker image tag
- `product_api_version` (string) - Docker image tag
- `product_api_db_version` (string) - Docker image tag
- `posgres_db` (string) - Postgres DB User
- `postgress_password` (string) - Postgres DB Password
- `frontend_ui_port` (string) - Frontend UI Port
- `public_api_port` (string) - Public API service port used by clientside requests


## To Do
- Create a nomad template that doesn't use consul with Hashicups for times when `register_consul_service=false`
- Incorporate Vault option for secrets