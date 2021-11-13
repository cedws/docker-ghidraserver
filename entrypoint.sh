#!/bin/bash

set -e

chown -R ghidra:ghidra /srv/repositories

exec su ghidra -c "/start.sh $@"