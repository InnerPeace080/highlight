#!/bin/bash -e

./telemetry.sh
source env.sh --go-docker

if [ -f "$ADMIN_PASSWORD" ]; then
  echo 'Exiting because no ADMIN_PASSWORD_FOUND'
  exit 1
fi

./start-infra.sh --go-docker

if ! docker compose -f compose.local.yml up --build --detach backend frontend >>/tmp/highlightSetup.log 2>&1; then
  echo 'Failed to start highlight hobby edition.'
  docker ps -a
  cat /tmp/highlightSetup.log
  exit 1
fi

echo "Highlight started on ${REACT_APP_FRONTEND_URI}"
wait
