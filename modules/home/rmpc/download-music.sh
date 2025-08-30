URL="$1"
DOWNLOAD_DIR="$HOME/Music/downloads"

yt-dlp -x --audio-format flac \
    --audio-quality 0 \
    --add-metadata \
    --embed-thumbnail \
    -P "$DOWNLOAD_DIR" \
    -o "%(artist)s - %(title)s.%(ext)s" \
    "$URL" \
&& \
beet import "$DOWNLOAD_DIR"

rm "$DOWNLOAD_DIR"/*
