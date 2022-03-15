Congrats on deploying [[ .nomad_pack.pack.name ]]

After deploying hashicups, you will need to enable consul intentions as follows:

# Consul Intensions
frontend -> product-public-api
product-api -> product-db
product-public-api -> payment-api
product-public-api -> product-api
