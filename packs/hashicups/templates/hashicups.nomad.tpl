job "hashicups" {
  type   = "service"
  region = "[[ .hashicups.region ]]"
  datacenters = [ [[ range $idx, $dc := .hashicups.datacenters ]][[if $idx]],[[end]][[ $dc | quote ]][[ end ]] ]

  group "hashicups" {
    network {
      port "db" { 
        static = 5432
        to = 5432
      }
      port "product-api" {
        static = 9090
        to = 9090
      }
      port "frontend" {
        static = 3000
        to = 3000
      }
      port "payments-api" {
        static = 8080
        to = 8080
      }
      port "public-api" {
        static = 8081
        to = 8081
      }
      port "nginx" {
        static = 80
        to = 80
      }
    }

    task "db" {
      driver = "docker"
      config {
        image   = "hashicorpdemoapp/product-api-db:[[ .hashicups.product_api-db_version ]]"
        ports = ["db"]
      }
      env {
        POSTGRES_DB       = "products"
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "password"
      }
    }

    task "product-api" {
      driver = "docker"
      config {
        image   = "hashicorpdemoapp/public-api:[[ .hashicups.public_api_version ]]"
        ports = ["product-api"]
      }
      env {
        DB_CONNECTION = "host=${NOMAD_IP_db} port=5432 user=postgres password=password dbname=products sslmode=disable"
        BIND_ADDRESS = "0.0.0.0:9090"
      }
    }

    task "payment-api" {
      driver = "docker"
      config {
        image   = "hashicorpdemoapp/payments:[[ .hashicups.payments_version ]]"
        ports = ["payments-api"]
      }
    }
    
    task "public-api" {
      driver = "docker"
      config {
        image   = "hashicorpdemoapp/public-api:[[ .hashicups.public_api_version ]]"
        ports = ["public-api"]
      }
      env {
        BIND_ADDRESS = ":8081"
        PRODUCT_API_URI = "http://${NOMAD_IP_product-api}:${NOMAD_HOST_PORT_product-api}"
        PAYMENT_API_URI = "http://${NOMAD_IP_payments-api}:${NOMAD_HOST_PORT_payments-api}"
      }
    }
    
    task "frontend" {
      driver = "docker"
      env {
        NEXT_PUBLIC_PUBLIC_API_URL= "/"
      }
      config {
        image   = "hashicorpdemoapp/frontend:[[ .hashicups.frontend_version ]]"
        ports = ["frontend"]
      }
    }

    task "nginx" {
      driver = "docker"
      config {
        image = "nginx:alpine"
        ports = ["nginx"]
        mount {
          type   = "bind"
          source = "local/default.conf"
          target = "/etc/nginx/conf.d/default.conf"
        }
      }
      template {
        data =  <<EOF
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=STATIC:10m inactive=7d use_temp_path=off;
upstream frontend_upstream {
  server {{ env "NOMAD_IP_frontend" }}:3000;
}
server {
  listen 80;
  server_name  {{ env "NOMAD_IP_nginx" }};
  server_tokens off;
  gzip on;
  gzip_proxied any;
  gzip_comp_level 4;
  gzip_types text/css application/javascript image/svg+xml;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection 'upgrade';
  proxy_set_header Host $host;
  proxy_cache_bypass $http_upgrade;
  location /_next/static {
    proxy_cache STATIC;
    proxy_pass http://frontend_upstream;
    # For testing cache - remove before deploying to production
    add_header X-Cache-Status $upstream_cache_status;
  }
  location /static {
    proxy_cache STATIC;
    proxy_ignore_headers Cache-Control;
    proxy_cache_valid 60m;
    proxy_pass http://frontend_upstream;
    # For testing cache - remove before deploying to production
    add_header X-Cache-Status $upstream_cache_status;
  }
  location / {
    proxy_pass http://frontend_upstream;
  }
  location /api {
    proxy_pass http://{{ env "NOMAD_IP_frontend" }}:8081;
  }
}
        EOF
        destination = "local/default.conf"
      }
    }
  }
}
