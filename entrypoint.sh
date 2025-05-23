#!/bin/bash
set -e

# Start CouchDB in the background
/docker-entrypoint.sh couchdb &

# Wait for CouchDB to be up
until curl -s http://127.0.0.1:5984/_up > /dev/null; do
  echo "Waiting for CouchDB..."
  sleep 1
done

echo "Set up a single node cluster..."
curl -fs -X PUT http://${COUCHDB_USER}:${COUCHDB_PASSWORD}@127.0.0.1:5984/_users || true
curl -fs -X PUT http://${COUCHDB_USER}:${COUCHDB_PASSWORD}@127.0.0.1:5984/_replicator || true

echo "Ensuring database 'inkdrop-db' exists..."
curl -fs -X PUT http://${COUCHDB_USER}:${COUCHDB_PASSWORD}@127.0.0.1:5984/inkdrop-db || true

# Wait for background CouchDB to finish (take over PID 1)
wait %1
