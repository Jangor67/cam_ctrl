rpicam-vid \
  -t 0 \
  --framerate=5 \
  --inline -o - | \
ffmpeg \
  -fflags nobuffer \
  -flags low_delay \
  -probesize 32 \
  -analyzeduration 0 \
  -i - \
  -c:v libx264 \
  -preset ultrafast \
  -tune zerolatency \
  -g 10 \
  -f rtsp rtsp://localhost:8554/mystream
