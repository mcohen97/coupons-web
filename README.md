# README


# Uso en development

Para poder levantar en development el sistema, debemos instalar postgres en la maquina.

Para instalar postgres: [install postgres](http://postgresguide.com/setup/install.html)

## Paquetes apt para linux

> sudo apt update  
> sudo apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev (para rails)  
> sudo apt install postgresql postgresql-contrib (para postgres)  
> sudo apt-get install libpq-dev (para postgres tambien)

## Como configurar

Teniendo el postgres ya instalado, debemos que crear el usuario y contraseña con estos comandos

> sudo su - postgres  
> psql  
> create role coupons with createdb login password 'coupons';

Luego, salir de postgres (con ctrl d) y reiniciamos la base

> sudo systemctl restart postgresql

En este caso, nuestros usuario y contraseña de la base de datos son 'coupons' y 'coupons'. Esto hay que ponerlo en el archivo local_env.yml, que contiene las variables de entorno:

DB_USERNAME: 'coupons'
DB_PASSWORD: 'coupons'
RAILS_SERVE_STATIC_FILES: 'true'
DB_HOST: 'localhost'
JWT_SECRET: 'somesecret'
RAILS_MASTER_KEY: 'somekey'
HOSTS: 'localhost'


* ...

