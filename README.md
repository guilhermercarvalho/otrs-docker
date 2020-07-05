# OTRS Docker

Esta imagem tem como objetivo facilitar a instalação e configuração do OTRS para a realização de testes. Utiliza OTRS em sua versão **6.0.23**.

## Utilização

### Requisios mínimos

É necessário ter instalado em sua máquina:

- [docker](https://docs.docker.com/get-docker/)
- [docker-compose](https://docs.docker.com/compose/install/)

### Informações Básicas

Para realizar configuração e integração com outros serviços optei por criar uma rede isolada para os containers.
Como banco de dados utilizarei MySQL em sua versão 5.7 (suportada pelo OTRS-6.0.23).

- **IP OTRS**: 172.21.0.2
- **IP MySQL**: 172.21.0.3

### Execução

Para executar a imagem:

```sh
docker-compose up -d --build
```

Após o *build*, acesse a *url* de instalação padrão do OTRS: http://172.21.0.2/otrs/installer.pl

Siga os passos de configuração e realize *login* como *root@localhost*.

Após *logar* como *root@localhost* execute:

```sh
docker exec otrs_6.0.23 /bin/sh /root/after_install.sh
```

Isso irá executar o Daemon do OTRS e instalar os principais módulos da aplicação.

E por fim, para matar o serviço execute:

```sh
docker-compose down
```
