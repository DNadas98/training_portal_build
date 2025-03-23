# training_portal_build

### Setup

- Copy `env.txt` and rename to `.env`, modify values
- Run `docker login`

- Run ./certbot.sh <EMAIL> <DOMAIN>
- Add ./certbot-renev.sh to crontab:

```bash
# Copy this line:
0 3 * * * /bin/bash <PROJECT PATH>/certbot-renew.sh > /dev/null 2>> <PROJECT PATH>/certbot-renew.log
#Paste and save in crontab:
crontab -e
```

### Run

- Run `docker-compose up --build -d`

### Modify versions

- Set the frontend version in the first line of `<PROJECT PATH>/nginx/Dockerfile`
- Set the backend version in `docker-compose.yml`

