# Inception

A Docker containerization project that sets up a complete web development environment using multiple containers. This project implements a multi-service infrastructure using Docker Compose, developed as part of the 42 school curriculum.

## 🔧 Services

- NGINX web server with TLSv1.2/1.3
- WordPress + PHP-FPM
- MariaDB database
- Custom Docker network
- Persistent volume configuration
- Docker-compose orchestration

## 🛠️ Prerequisites

- Docker Engine
- Docker Compose
- Make
- Linux/Unix-based system

## 🚀 Installation

1. Clone the repository:

git clone https://github.com/mrioshe42/Inception.git
cd Inception

## 📁 Project Structure
srcs/: Source files and configurations
docker-compose.yml: Services orchestration
requirements/: Individual service configurations
nginx/: NGINX configuration
wordpress/: WordPress setup
mariadb/: Database configuration
Makefile: Build and deployment commands

## 🔍 Usage
Start containers: make up
Stop containers: make down
Clean environment: make clean
Show container status: make ps

## 👤 Author
mrioshe42

## 📝 License
This project is part of the 42 school curriculum.
