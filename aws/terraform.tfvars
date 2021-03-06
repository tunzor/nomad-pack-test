
   
# If any required variables are not provided here,
# they will be requested interactively.
# `name` (required) is used to override the default 
# decorator for elements in the stack. This allows
# for more than one environment per account.
# This name can only contain alphanumeric characters.
name = "nomad"

# `key_name` (required) -  The name of the AWS SSH
# keys to be loaded on the instance at provisioning.  
key_name = "arusso-us-east-1"

# `nomad_binary` (optional, null) - URL of a zip file 
# containing a nomad executable with which to replace
# the Nomad binaries in the AMI.
# Typically this is left commented unless necessary. 
# nomad_binary = "https://releases.hashicorp.com/nomad/0.10.0/nomad_0.10.0_linux_amd64.zip"

# `region` ("us-east-1") - sets the AWS region to
# build your cluster in.
region = "us-east-1"

# `ami` (required) - The base AMI for the created
# nodes. This AMI must exist in the requested region
# for this environment to build properly.

# Image built with ../../packer.json
ami = "ami-0ddf0df00b2301f06"

# These options control instance size and count. 
# They should be set according to your needs.
server_instance_type            = "t2.micro"
server_count                    = "3"
client_instance_type            = "t2.micro"
client_count                    = "3"
targeted_client_instance_type   = "t2.micro"
targeted_client_count           = "0"

# `whitelist_ip` (required) - IP to whitelist for the
# security groups (set to 0.0.0.0/0 for world).  
whitelist_ip = "69.166.116.23/32"

# Token Accessor and Secret IDs used to create the
# Nomad server and client token for Consul auto-join.
# Must be a UUID
nomad_consul_token_id = "3bb9cb88-9aa4-4cb4-bfef-483adfbe850a"
nomad_consul_token_secret = "fa97974d-b693-4a85-a369-11b001c5ad5f"