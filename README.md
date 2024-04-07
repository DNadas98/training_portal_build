# training_portal_build

### Setup
- Overwrite ssl cert and key in `nginx/ssl/`
- Overwrite `nginx/nginx.conf` with server config
- Copy `env.txt` and rename to `.env`, modify values

### Run
- Run `docker-compose up -d --build`
