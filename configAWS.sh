# Intala python e pip
sudo apt install python3-pip

# Instala AWS CLI
pip install awscli --break-system-packages 

## Configura AWS

[ -f .env ] && export $(grep -v '^#' .env | xargs)

if [ -d ~/.aws ]; then
    echo "Já existe um arquivo de configuração!"
else
    mkdir ~/.aws
fi

if [ -e ~/.aws/credentials ] ; then
    echo "Já existe credenciais!"
    # echo "[otavio]" >> ~/.aws/credentials
else

echo "[otavio]" > ~/.aws/credentials
echo aws_access_key_id = "$AWS_KEY" >> ~/.aws/credentials
echo aws_secret_access_key = "$AWS_SECRET_KEY" >> ~/.aws/credentials

echo "Credencial configurada!"
fi

echo "Configurando AWS com perfil adicionado..."
aws configure set region "$AWS_DEFAULT_REGION" --profile otavio

aws ecr get-login-password --region "$AWS_DEFAULT_REGION" --profile otavio | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr."$AWS_DEFAULT_REGION".amazonaws.com

echo "AWS configurada!"