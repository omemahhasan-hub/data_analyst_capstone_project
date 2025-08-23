CREATE DATABASE capstone ;
CREATE USER 'oh'@'localhost' IDENTIFIED BY 'hasan1';
GRANT ALL PRIVILEGES ON capstone.* TO 'oh'@'localhost';
FLUSH PRIVILEGES;
USE capstone;