# Prepare archive with function sources
data "archive_file" "auth-fn-src" {
  output_path = "${path.module}/dist/auth-fn-src.zip"
  type        = "zip"
  source {
    content  = file("${path.module}/auth-fn.js")
    filename = "auth-fn.js"
  }
}

# Create function
resource "yandex_function" "ip-auth-function" {
  name              = "ip-authorizer"
  entrypoint        = "auth-fn.handler"
  memory            = 128
  runtime           = "nodejs16"
  execution_timeout = 5
  user_hash         = data.archive_file.auth-fn-src.output_base64sha256
  content {
    zip_filename = data.archive_file.auth-fn-src.output_path
  }
  environment = {
    ALLOW_FROM_IP = var.allow-from-ip
  }
}

# Service account for API Gateway
resource "yandex_iam_service_account" "gateway-sa" {
  name = "my-gateway-sa"
}

# Allow auth function invocation for gateway's sa
resource "yandex_function_iam_binding" "apigw-invokes-auth-fn" {
  function_id = yandex_function.ip-auth-function.id
  members     = ["serviceAccount:${yandex_iam_service_account.gateway-sa.id}"]
  role        = "serverless.functions.invoker"
}

# Create API Gateway
resource "yandex_api_gateway" "gateway" {
  name = "my-api-gateway"
  spec = templatefile("${path.module}/gateway-spec-template.yaml", {
    AUTH_FUNCTION_ID = yandex_function.ip-auth-function.id
    GATEWAY_SA_ID    = yandex_iam_service_account.gateway-sa.id
  })
}

output "gateway-address" {
  value = "https://${yandex_api_gateway.gateway.domain}"
}

# configuration
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  folder_id = var.folder-id
  token     = var.yc-token
}

variable "folder-id" {
  type = string
}

variable "yc-token" {
  type = string
}

variable "allow-from-ip" {
  type = string
}