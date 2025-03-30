# training_portal_build

### Setup

- Copy `env.txt` and rename to `.env`, copy `env_backup.txt` and rename to `.env.backup` modify values
- Run `docker login`
- Add to crontab:

```bash
# Copy this line:
*/30 * * * * /home/tesztsor/training_portal_build/db_backup.sh > /var/tesztsor_backup/backup.log 2>&1
```

### Run

- Run `docker-compose up --build -d`

### Modify versions

- Set the frontend version in the first line of `<PROJECT PATH>/nginx/Dockerfile`
- Set the backend version in `docker-compose.yml`

