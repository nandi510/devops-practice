-- Init script runs once on first container start
CREATE DATABASE IF NOT EXISTS appdb;
USE appdb;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed data
INSERT IGNORE INTO users (name, email) VALUES
  ('Alice Dev', 'alice@example.com'),
  ('Bob Ops', 'bob@example.com');
