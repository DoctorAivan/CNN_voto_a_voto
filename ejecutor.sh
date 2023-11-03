#!/bin/sh

# Esperamos 3 segundos antes de ejecutar
sleep 3;

# Ruta donde guardamos dump
path_dump="/var/www/html/vav/app.dump";

# Timestamp de dump
timestamp=`date +'%Y%m%d%H%M%S'`;

# Borrar esquema
psql "postgresql://app_vav:nBwMQ6lj6OK2kAoI@localhost/VAV" -c "drop schema public cascade;create schema public;";

# Pedir dump a servidor y guardar local
ssh ivillarroel@10.3.75.100 "cat /var/www/html/vav/app.dump/vav.sql" > $path_dump/vav-$timestamp.sql;

# Tomar dump local y enviarlo a postgres
cat $path_dump/vav-$timestamp.sql| psql "postgresql://app_vav:nBwMQ6lj6OK2kAoI@localhost/VAV";

# Comprimir dump para guardar
gzip $path_dump/vav-$timestamp.sql