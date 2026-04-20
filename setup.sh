#!/bin/bash

set -e

SUNWAIT_BIN="/usr/local/bin/sunwait"
LAT="52.37N"
LON="4.89E"

DAY_SCRIPT="$PWD/day.sh"
NIGHT_SCRIPT="$PWD/night.sh"
MIDNIGHT_SCRIPT="$PWD/midnight.sh"

CRON_TMP=$(mktemp)

echo "== Controleer sunwait =="

if [ ! -f "$SUNWAIT_BIN" ]; then
    echo "sunwait niet gevonden, installeren..."
    if [ ! -f "/usr/bin/make" ]; then
      echo "first install build essential e.g."
      echo "sudo apt install build-essential"
      exit 1
    fi

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
SUNRISE_CRON="0 5 * * * $SUNWAIT_BIN wait rise $LAT $LON && $DAY_SCRIPT"

# Sunset cron (iets vóór vroegste sunset)
SUNSET_CRON="0 16 * * * $SUNWAIT_BIN wait set $LAT $LON && $NIGHT_SCRIPT"

# Midnight cron (rond uitschakelen verlichting)
MIDNIGHT_CRON="0 23 * * * $MIDNIGHT_SCRIPT"

grep -F "PATH" "$CRON_TMP" > /dev/null || {
    echo "PATH=$PATH" >> "$CRON_TMP"
    echo "PATH toegevoegd"
}

echo "== Voeg sunrise job toe indien nodig =="

grep -F "$DAY_SCRIPT" "$CRON_TMP" > /dev/null || {
    echo "$SUNRISE_CRON" >> "$CRON_TMP"
    echo "Sunrise job toegevoegd."
}

echo "== Voeg sunset job toe indien nodig =="

grep -F "$NIGHT_SCRIPT" "$CRON_TMP" > /dev/null || {
    echo "$SUNSET_CRON" >> "$CRON_TMP"
    echo "Sunset job toegevoegd."
}
echo "== Voeg midnight job toe indien nodig =="

grep -F "$MIDNIGHT_SCRIPT" "$CRON_TMP" > /dev/null || {
    echo "$MIDNIGHT_CRON" >> "$CRON_TMP"
    echo "Midnight job toegevoegd."
}

echo "== Installeer nieuwe crontab =="

crontab "$CRON_TMP" || echo "error in nieuwe crontab: check below for error:" && cat "$CRON_TMP"
rm "$CRON_TMP"

echo "== Configureer en herstart service voor dit moment =="
POLL=$(sunwait poll $LAT $LON) || echo ""
if [ "$POLL" == "DAY" ]; then
    echo "== Running $DAY_SCRIPT Now =="
    $DAY_SCRIPT
else
    echo "== Running $NIGHT_SCRIPT Now =="
    $NIGHT_SCRIPT
fi

echo "Klaar!"
