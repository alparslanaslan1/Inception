# Inception

**Inception** is a Docker-based orchestration project that sets up and configures a full-stack web application environment using Docker Compose. It includes services for a MySQL database, WordPress, phpMyAdmin, Nginx, FTPS, and an FTP server.

## File Structure

```
Inception-main/
├── srcs/
│   ├── wordpress/            # WordPress setup scripts and configuration
│   │   ├── Dockerfile
│   │   ├── wp-config.php
│   │   └── setup.sh
│   ├── mysql/                # MySQL Dockerfile and initialization scripts
│   │   ├── Dockerfile
│   │   └── init.sql
│   ├── phpmyadmin/           # phpMyAdmin Dockerfile and config
│   │   └── Dockerfile
│   ├── nginx/                # Nginx configuration files
│   │   └── nginx.conf
│   ├── ftps/                 # FTPS server configuration
│   │   └── vsftpd.conf
│   ├── ftp/                  # FTP server configuration
│   │   └── pure-ftpd.conf
│   └── certificates/         # SSL/TLS certificates
│       ├── localhost.crt
│       └── localhost.key
├── docker-compose.yml        # Docker Compose orchestration file
├── .env                      # Environment variables for services
└── .gitignore                # Files to ignore in Git
```

## Prerequisites

* Docker and Docker Compose installed
* Sufficient system resources (CPU, RAM, Disk)

## Setup and Deployment

1. **Configure environment variables** in `.env`, such as database credentials and service ports.
2. **Build and start services**:

   ```bash
   docker-compose up --build -d
   ```
3. **Verify running containers**:

   ```bash
   docker-compose ps
   ```
4. **Access services**:

   * WordPress: `http://localhost:5050`
   * phpMyAdmin: `http://localhost:5000`
   * FTPS: `ftps://localhost:21`

## Service Details

* **WordPress**: PHP-based CMS, configured with MySQL and mounted volumes for persistent data.
* **MySQL**: Relational database, initialized with `init.sql` scripts.
* **phpMyAdmin**: Web-based MySQL administration.
* **Nginx**: Reverse proxy and SSL termination, configured via `nginx.conf`.
* **FTPS & FTP**: Secure and standard file transfer services.

## Usage

* To stop and remove services:

  ```bash
  docker-compose down
  ```
* To view logs:

  ```bash
  docker-compose logs -f
  ```

## Author

* **Alparslan Aslan** ([alparslanaslan504@gmail.com](mailto:alparslanaslan504@gmail.com))

## License

No explicit license provided. Use, modify, and distribute at your own risk.
