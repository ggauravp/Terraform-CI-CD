#!/bin/bash

# Update packages and install Postgres
apt update -y
apt install postgresql postgresql-contrib -y

# Ensure Postgres service is running
systemctl enable postgresql
systemctl start postgresql

# Set password for default 'postgres' user
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'yourpassword';"

# Create database if it doesn't exist
sudo -u postgres psql -c "CREATE DATABASE sampledb;"

# Create table if it doesn't exist
sudo -u postgres psql -d sampledb -c "
CREATE TABLE IF NOT EXISTS table_name (
    col1 text,
    col2 text,
    col3 text
);"
