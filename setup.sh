#!/bin/bash

set -e

SUNWAIT_BIN="/usr/local/bin/sunwait"
LAT="52.37N"
LON="4.89E"

SUNRISE_SCRIPT="$PWD/sunrise.sh"
SUNSET_SCRIPT="$PWD/sunset.sh"

CRON_TMP=$(mktemp)

echo "== Controleer sunwait =="

if [ ! -f "$SUNWAIT_BIN" ]; then
    echo "sunwait niet gevonden, installeren..."

    cd "$HOME"
    if [ ! -d "sunwait" ]; then
        git clone https://github.com/risacher/sunwait.git
    fi

    cd sunwait
    make
    sudo cp sunwait /usr/local/bin

    echo "sunwait geïnstalleerd."
else
    echo "sunwait al aanwezig."
fi

echo "== Controleer crontab =="

crontab -l 2>/dev/null > "$CRON_TMP" || true

# Sunrise cron (iets vóór vroegste sunrise)
SUNRISE_CRON="0 5 * * * $SUNWAIT_BIN sun up $LAT $LON && $SUNRISE_SCRIPT"

# Sunset cron (iets vóór vroegste sunset)
SUNSET_CRON="0 16 * * * $SUNWAIT_BIN sun down $LAT $LON && $SUNSET_SCRIPT"

echo "== Voeg sunrise job toe indien nodig =="

grep -F "$SUNRISE_SCRIPT" "$CRON_TMP" > /dev/null || {
    echo "$SUNRISE_CRON" >> "$CRON_TMP"
    echo "Sunrise job toegevoegd."
}

echo "== Voeg sunset job toe indien nodig =="

grep -F "$SUNSET_SCRIPT" "$CRON_TMP" > /dev/null || {
    echo "$SUNSET_CRON" >> "$CRON_TMP"
    echo "Sunset job toegevoegd."
}

echo "== Installeer nieuwe crontab =="

crontab "$CRON_TMP"
rm "$CRON_TMP"

echo "Klaar!"
