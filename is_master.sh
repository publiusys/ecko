#!/bin/bash

if [[ "$(hostname -I)" == *"10.10.1.1"* ]]; then
  echo "MASTER"
fi
