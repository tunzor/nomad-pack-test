job "hashicups" {
  type   = "service"
  region = "[[ .hashicups.region ]]"
  datacenters = [ [[ range $idx, $dc := .hashicups.datacenters ]][[if $idx]],[[end]][[ $dc | quote ]][[ end ]] ]

  group "frontend" {
    network {
      mode = "bridge"
      port "http" {
        static = [[ .hashicups.frontend_ui_port ]]
      }
    }

    [[ if .hashicups.register_consul_service ]]
    service {
      name = "frontend"
      port = "[[ .hashicups.frontend_ui_port ]]"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "product-public-api"
              local_bind_port  = 8080
            }            
          }
        }
      }
    }
    [[ end ]]

    task "frontend" {
      driver = "docker"

      env {
          PORT = [[ .hashicups.frontend_ui_port ]]
      }

      config {
        image = "hashicorpdemoapp/frontend:v[[ .hashicups.frontend_version ]]"
        ports = ["http"]
        extra_hosts = ["public-api:127.0.0.1"]
        mount {
          type   = "bind"
          source = "local/default.conf"
          target = "/etc/nginx/conf.d/default.conf"
        }
      }

      template {
        data = <<-EOH
        server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }
        location /api {
            proxy_pass http://127.0.0.1:8080;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
        }
        EOH
        destination = "local/default.conf"
      }
    }
  }

  group "product-public-api" {
    network {
      mode = "bridge"
    }

    [[ if .hashicups.register_consul_service ]]
    service {
      name = "product-public-api"
      port = "8080"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "product-api"
              local_bind_port  = 5000
            }            
            upstreams {
              destination_name = "payment-api"
              local_bind_port  = 5001
            }
          }
        }
      }
    }
    [[ end ]]

    task "product-public-api" {
      driver = "docker"

      config {
        image   = "hashicorpdemoapp/public-api:v[[ .hashicups.public_api_version ]]"
      }

      env {
        PRODUCT_API_URI = "http://localhost:5000"
        PAYMENT_API_URI = "http://localhost:5001"
      }
    }
  }

  group "payment-api" {
    network {
      mode = "bridge"
    }

    [[ if .hashicups.register_consul_service ]]
    service {
      name = "payment-api"
      port = "8080"

      connect {
        sidecar_service {}
      }
    }
    [[ end ]]

    task "payment-api" {
      driver = "docker"

      config {
        image = "hashicorpdemoapp/payments:v[[ .hashicups.payments_version ]]"
      }
    }
  }

  group "product-api" {
    network {
      mode = "bridge"
      port "healthcheck" {
        to = -1
      }
    }

    [[ if .hashicups.register_consul_service ]]
    service {
      name = "product-api"
      port = "9090"

      check {
        type     = "http"
        path     = "/health"
        interval = "5s"
        timeout  = "2s"
        expose   = true
        port     = "healthcheck"
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "product-db"
              local_bind_port  = 5000
            }
          }
        }
      }
    }
    [[ end ]]

    task "product-api" {
      driver = "docker"

      config {
        image   = "hashicorpdemoapp/product-api:v[[ .hashicups.product_api_version ]]"
      }

      env {
        CONFIG_FILE = "/config/config.json"
				DB_CONNECTION = "host=localhost port=5000 user=[[ .hashicups.postgres_user ]] password=[[ .hashicups.postgress_password ]] dbname=[[ .hashicups.posgres_db ]] sslmode=disable"
				BIND_ADDRESS = "0.0.0.0:9090"
      }
    }
  }

  group "product-db" {
    network {
      mode = "bridge"
    }

    [[ if .hashicups.register_consul_service ]]
    service {
      name = "product-db"
      port = "5432"

      connect {
        sidecar_service {}
      }
    }
    [[ end ]]

    task "db" {
      driver = "docker"

      config {
        image = "hashicorpdemoapp/product-api-db:v[[ .hashicups.product_api_db_version ]]"
      }

      env {
        POSTGRES_DB       = "[[ .hashicups.posgres_db ]]"
        POSTGRES_USER     = "[[ .hashicups.postgres_user ]]"
        POSTGRES_PASSWORD = "[[ .hashicups.postgress_password ]]"
      }
    }
  }
}
