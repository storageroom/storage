#!/bin/bash
git add .
usuasuausuausausuasu=$(date +%d/%m)
git commit -m "🌈 $usuasuausuausausuasu"
git push origin main || exit
curl https://betteruptime.com/api/v1/heartbeat/zfnS1uFSeYdSwQY41Na7mMRW
