CREATE DATABASE user_management_system;

USE user_management_system;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(20) DEFAULT 'Employee'
);


CREATE TABLE software (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    accessLevels VARCHAR(255)
);

CREATE TABLE requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    softwareId INT,
    accessType VARCHAR(20),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (userId) REFERENCES users(id),
    FOREIGN KEY (softwareId) REFERENCES software(id)
);


