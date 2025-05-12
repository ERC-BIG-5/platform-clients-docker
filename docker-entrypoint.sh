#!/bin/bash

# Ensure target directory exists
mkdir -p /platform-clients/data

# Fix permissions
chmod -R a+rw /platform-clients

# Only remove and recreate the symlink if it doesn't point to the right place
if [ ! -L "/app/platform-clients/data" ] || [ "$(readlink /app/platform-clients/data)" != "/platform-clients/data" ]; then
  # Remove the existing data directory/symlink
  rm -rf /app/platform-clients/data
  # Create the symlink
  ln -s /platform-clients/data /app/platform-clients/data
fi

# Add or update data from backup if target is empty
if [ -z "$(ls -A /platform-clients/data 2>/dev/null)" ]; then
  cp -r /app/data-backup/* /platform-clients/data/ 2>/dev/null || true
  # Make sure new files have proper permissions
  chmod -R a+rw /platform-clients/data
fi

# Execute the command passed to docker run
exec "$@"