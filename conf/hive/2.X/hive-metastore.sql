CREATE USER hiveuser WITH PASSWORD 'mypassword';

CREATE DATABASE metastore;

GRANT ALL PRIVILEGES ON DATABASE metastore TO hiveuser;