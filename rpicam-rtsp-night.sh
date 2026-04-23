rpicam-vid \
  -t 0 \
  --shutter 250000 \
  --gain 10 \
  --framerate=4 \
  --inline -o - | \
ffmpeg -i - \
  -c:v libx264 \
  -g 10 -preset veryfast \
  -f rtsp rtsp://localhost:8554/mystream
