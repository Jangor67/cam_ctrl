#!/bin/bash
set -e

LINK="rpicam-rtsp.sh"
TARGET="rpicam-rtsp-midnight.sh"
SERVICE="camera-rtsp.service"

echo "== Controleer target script =="

if [ ! -f "$TARGET" ]; then
    echo "Fout: $TARGET bestaat niet"
    exit 1
fi

echo "== Update symlink =="

ln -sf "$TARGET" "$LINK"

echo "Symlink gezet: $LINK -> $TARGET"

echo "== Herstart service =="

sudo systemctl restart "$SERVICE"

echo "== Status =="

systemctl status "$SERVICE" --no-pager

echo "Klaar!"
