## Realizar o build da imagem docker
```sh
docker compose build
```

## Subir a imagem docker
```sh
docker compose up -d
```

## Criando certificado
- Acesse o container docker do nginx, e então execute o seguinte comando:
```sh
certbot --nginx
```

## Renovar certificado
- Repita o mesmo passo da criação de certificado
