# Atenção, este Dockerfile foi feito para ser usado em containers com ALPINE, outras versões de linux podem ser incompativeis
# Use a versão do NGINX especificada ou use uma versão padrão
ARG NGINX_VERSION=${NGINX_VERSION}
FROM nginx:${NGINX_VERSION}-alpine

# #CONFIGURAÇÕES AWS
# ARG AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
# ARG AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID}
# ARG AWS_KEY=${AWS_KEY} 
# ARG AWS_SECRET_KEY=${AWS_SECRET_KEY}

# Copia o arquivo de configuração nginx.conf personalizado para o contêiner
COPY nginx/nginx.conf /etc/nginx/

# Atualiza e instala os pacotes necessários
RUN apk update && apk upgrade && \
    apk --update add logrotate openssl bash nano

# certbot certbot-nginx são os responsáveis pela geração de HTTPS
RUN apk add --no-cache certbot certbot-nginx

# Instala NodeJS, YARN, Python e PIP
RUN apk add --no-cache nodejs yarn python3 py3-pip

# Instala gerenciador de serviços Alpine
RUN apk add openrc

# Instala AWSCLI e dependencias
# RUN pip install awscli --break-system-packages 

# Remove a configuração padrão do NGINX
RUN rm -rf /etc/nginx/conf.d/default.conf

# add user www-data
RUN adduser -D -H -u 1000 -s /bin/bash www-data -G www-data

# Cria diretórios para o conteúdo do site e dá suas respectivas permissões
RUN mkdir -p /var/www && \
    chown -R www-data:www-data /var/www && \
    chmod 755 -R /var/www

# Cria diretórios para as configurações do NGINX
RUN mkdir -p /etc/nginx/sites-available  && \
    chown -R www-data:www-data /etc/nginx/sites-available 

# Define o diretório de trabalho para o NGINX
WORKDIR /etc/nginx

# Limpeza: Remove pacotes não utilizados para reduzir o tamanho da imagem
RUN apk del --no-cache

# Envia arquivo para configuração da AWS
# COPY ./configAWS.sh /etc/nginx/ConfigAWS.sh

# RUN sh ConfigAWS.sh

# Inicia o NGINX quando o contêiner é executado
CMD ["nginx", "-g", "daemon off;"]

