rpicam-vid \
  -t 0 \
  --shutter 250000 \
  --gain 10 \
  --framerate=4 \
  --inline -o - | \
ffmpeg \
  -re \
  -i - \
  -vcodec copy \
  -f rtsp rtsp://localhost:8554/mystream
