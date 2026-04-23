rpicam-vid \
  -t 0 \
  --framerate=5 \
  --inline -o - | \
ffmpeg -i - \
  -c:v libx264 \
  -g 10 -preset veryfast \
  -f rtsp rtsp://localhost:8554/mystream
