# pg-redis-ext

pg-redis-ext is a postgresql extension example.
It creates a method to send data to redis via postgresql.

-- Tested on linux (ubuntu server 16) only --

## Steps

* install postgresql
* install postgresql-server-dev-X.Y (where X.Y is the postgresql server version)
* create extension files (makefile, extension--0.0.1.sql [in this format], extension.c, extension.control) or use the ones provided here
* in order to link custom libs, you must edit or make your own makefile
* run make install
* query CREATE EXTENSION extension-name
* use your extension methods and functions from postgresql

For more info, take a look at the provided files