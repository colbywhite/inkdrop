# Self-host a sync server for Inkdrop

This project makes it easy to host your own [sync server] for Inkdrop.
You just need to deploy an instance of CouchDB.

## Notes

- Runs CouchDB as a single-node cluster.
- Creates an `inkdrop-db` database.
- Deploys on Railway using a Docker image.

# Deploy on Railway

1. Set env variables in Railway UI; see `.env.example`.
2. Configure Railway to deploy your repo. `railway.toml` will build and deploy the `Dockerfile`.
3. Add a volume in Railway UI (CMD + K -> Volume); mount on `/opt/couchdb/data`.
4. Run build.
5. Add TCP proxy in Railway UI (Settings -> Networking) to get public URL. (Referred to as `RAILWAY_URL` in next step.)
6. Your sync URL for Inkdrop will be `http://${COUCHDB_USER}:${COUCHDB_PASSWORD}@${RAILWAY_URL}/inkdrop-db`

# Run DB locally

Set env variables in `.env` first; see `.env.example`.

```shell
# Build and run image
docker build -t inkdrop-db .
docker run -d --rm \
  --name inkdrop-db \
  --env-file .env \
  -v ./data:/opt/couchdb/data \
  -p 5984:5984 \
  inkdrop-db
```

Local CouchDB running at http://localhost:5984/_utils.
Sync URL for Inkdrop will be `http://${COUCHDB_USER}:${COUCHDB_PASSWORD}@localhost:5984/inkdrop-db`.
(Note that a localhost URL can't actually be used in Inkdrop. This is just for testing.)

```shell
# Tear down local container
docker stop inkdrop-db
rm -rf data
```

[sync server]: https://docs.inkdrop.app/reference/note-synchronization#how-to-set-up-your-own-sync-server
