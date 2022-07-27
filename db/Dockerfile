FROM postgres:13.1-alpine
ENV POSTGRES_USER compose-postgres
ENV POSTGRES_PASSWORD compose-postgres

COPY init.sql /docker-entrypoint-initdb.d/