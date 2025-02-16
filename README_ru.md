# Демонстрационный IP-авторайзер для API Gateway в Yandex Cloud

В этом примере показано, как настроить авторизацию по IP-адресу для ограниченного доступа к ресурсам API Gateway.

## Развертывание с помощью Terraform

Инициализируйте Terraform:
```shell
terraform init
```

Примените спецификацию Terraform, указав идентификатор вашего каталога в Yandex Cloud и IP-адрес, который должен иметь доступ к вашему API Gateway:
```shell
terraform apply -var "yc-token=$(yc iam create-token)" -var "folder-id=<Your Folder ID>" -var "allow-from-ip=<Allowed IP>"
```

Перейдите по ссылке, содержащей адрес шлюза, в браузере.
