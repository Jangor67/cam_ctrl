rpicam-vid \
  -t 0 \
  --shutter 2000000 \
  --gain 10 \
  --framerate=0.5 \
  --inline -o - | \
ffmpeg \
  -re \
  -i - \
  -vcodec copy \
  -f rtsp rtsp://localhost:8554/mystream
