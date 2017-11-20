#!/bin/bash
# Make sure s3fs is mounted and start streaming

# Make output s3fs dir
mkdir -p /mnt/dev-streaming-orcasound-net
s3fs -o default_acl=public-read dev-streaming-orcasound-net /mnt/dev-streaming-orcasound-net/
mkdir -p /mnt/dev-streaming-orcasound-net/$NODE_NAME
# symlink to s3 for output
ln -s /mnt/dev-streaming-orcasound-net/$NODE_NAME /tmp/dash_output_dir
# Start ALSA + ffmpeg
ffmpeg -t 0 -f alsa -i hw:$AUDIO_HW_ID -ac 1 -f mpegts udp://127.0.0.1:1234 &
# Start test engine live tools
./test-engine-live-tools/bin/live-stream -c ./config_audio.json udp://127.0.0.1:1234