#!/bin/bash

# Apply sysctl settings
sysctl vm.overcommit_memory=1

# Start Redis server
exec "$@"
