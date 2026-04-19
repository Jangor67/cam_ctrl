rpicam-vid \
  -t 0 \
  --inline -o - | \
ffmpeg \
  -re \
  -i - \
  -vcodec copy \
  -f rtsp rtsp://localhost:8554/mystream
