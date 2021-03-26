#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo 1. Вывести список из 10 пользователей.
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM users LIMIT 10"
echo " "

echo 2. Вывести список из 5 пользователей.
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM users LIMIT 5"
