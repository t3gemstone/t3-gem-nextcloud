# T3 Gemcloud Docker

## Usage

1. Change the admin user password in `files/admin_user_password.txt` — the default is insecure (`admin`).
2. Change database user passwords in `files/mysql_password.txt` - the default is insecure (`nextcloud`)
4. Generate a Tailscale auth key at https://login.tailscale.com/admin/settings/keys and paste it into `files/ts_auth_key.txt` - the default is invalid
5. Start the stack:

```bash
docker compose up -d
```

The first run may take 5–8 minutes (depending on your internet connection) to initialize Nextcloud apps and configuration. Then open http://gemcloud and log in with:Then open http://gemcloud and log in with:

- Username: `admin`
- Password: the contents of `files/admin_user_password.txt`

## Customization

- To change the container hostname (default: `gemcloud`), edit `CONTAINER_HOSTNAME` in the `.env` file. If your `ts_auth_key` is single-use, you must replace it after changing `CONTAINER_HOSTNAME`.
- By default, all data folders are created in a `data` folder in the current working directory (where you run the command). To change this, set `DATA_PATH_PREFIX` in the `.env` file.
