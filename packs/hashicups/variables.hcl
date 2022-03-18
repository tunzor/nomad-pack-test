variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["dc1"]
}

variable "region" {
  description = "The region where the job should be placed."
  type        = string
  default     = "global"
}

variable "frontend_version" {
  description = "Docker version tag"
  default = "v1.0.2"
}

variable "public_api_version" {
  description = "Docker version tag"
  default = "v0.0.6"
}

variable "payments_version" {
  description = "Docker version tag"
  default = "v0.0.12"
}

variable "product_api_version" {
  description = "Docker version tag"
  default = "v0.0.20"
}


variable "product_api_db_version" {
  description = "Docker version tag"
  default = "v0.0.20"
}

variable "posgres_db" {
  description = "Postgres DB name"
  default = "products"
}

variable "postgres_user" {
  description = "Postgres DB User"
  default = "postgres"
}

variable "postgress_password" {
  description = "Postgres DB Password"
  default = "password"
}

variable "frontend_ui_port" {
  description = "HTTP UI port"
  default = 80
}


variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = false
}

