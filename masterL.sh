#!/data/data/com.termux/files/usr/bin/bash

OUTPUT_DIR="./processed"
mkdir -p "$OUTPUT_DIR"

EXTENSIONS=("mp4" "mkv" "mov" "avi" "flv" "m4v" "mp3" "wav" "aac")

for ext in "${EXTENSIONS[@]}"; do
    for input in *."$ext"; do
        [ -e "$input" ] || continue

        filename="${input%.*}"
        output="$OUTPUT_DIR/${filename}_processed.mp4"

        echo "Processing: $input → $output"

        ffmpeg -i "$input" -c:v libx264 -preset ultrafast -crf 23 \
        -c:a aac -b:a 192k -af \
        "firequalizer=gain_entry='entry(80,2);entry(200,1);entry(800,0);entry(3000,1);entry(8000,1)', \
        acompressor=threshold=-10dB:ratio=1.5:attack=5:release=50, \
        alimiter=limit=0.85, \
        loudnorm=I=-18:TP=-1.0:LRA=7" \
        "$output"
    done
done

echo "✅ All files processed! Output saved in '$OUTPUT_DIR'"
