#!/bin/bash
gh auth login
cd /etc || printf "/etc does not exist?!?!?! nani?!?!?! mv it there manually"
gh repo clone storageroom/flexget
