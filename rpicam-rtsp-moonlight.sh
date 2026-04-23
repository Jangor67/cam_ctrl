rpicam-vid \
  -t 0 \
  --framerate 2 \
  --shutter 500000 \
  --gain 12 \
  --denoise cdn_off \
  --intra 4 \
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
  -g 4 \
  -f rtsp rtsp://localhost:8554/mystream
