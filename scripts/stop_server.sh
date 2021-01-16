#!/bin/bash
DESTROY=$(pgrep python3)
sudo kill -9 ${DESTROY}

