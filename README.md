# Yandex Cloud demo IP-authorizer for API Gateway

This example demonstrates how you can implement IP-based authorization to restrict access to your API Gateway resources.

## Deploying with terraform

Initialize terraform:
```shell
terraform init
```

Apply terraform spec, using your Yandex Cloud folder id and IP address that must have access to your API Gateway:
```shell
terraform apply -var "yc-token=$(yc iam create-token)" -var "folder-id=<Your Folder ID>" -var "allow-from-ip=<Allowed IP>"
```

Open printed gateway-address link in your web browser.