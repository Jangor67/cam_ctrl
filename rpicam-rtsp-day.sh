rpicam-vid \
  -t 0 \
  --framerate=5
  --inline -o - | \
ffmpeg \
  -re \
  -i - \
  -vcodec copy \
  -force_key_frames 0:00:05 \
  -f rtsp rtsp://localhost:8554/mystream
