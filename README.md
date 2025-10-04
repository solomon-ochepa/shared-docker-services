Docker `compose.yml` file that defines a shared network for phpMyAdmin and other services.

### Start container
```bash
docker-compose up -d
```

## System Image

### Build system image
```bash
docker build -t php-nodejs:8.3 -f docker/Dockerfile.php-nodejs .
```
