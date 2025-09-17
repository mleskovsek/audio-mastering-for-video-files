#!/data/data/com.termux/files/usr/bin/bash

# Output folder
OUTPUT_DIR="./processed"
mkdir -p "$OUTPUT_DIR"

# List of common video/audio extensions
EXTENSIONS=("mp4" "mkv" "mov" "avi" "flv" "m4v" "mp3" "wav" "aac")

# Loop through all files with the listed extensions
for ext in "${EXTENSIONS[@]}"; do
    for input in *."$ext"; do
        [ -e "$input" ] || continue

        filename="${input%.*}"
        output="$OUTPUT_DIR/${filename}_processed.mp4"

        echo "Processing: $input → $output"

        # Re-encode video (H.264) + audio (AAC) and apply audio mastering
        ffmpeg -i "$input" -c:v libx264 -preset ultrafast -crf 23 \
        -c:a aac -b:a 192k -af \
        "firequalizer=gain_entry='entry(80,2);entry(200,1);entry(800,0);entry(3000,1);entry(8000,1)', \
        acompressor=threshold=-15dB:ratio=3:attack=5:release=50, \
        alimiter=limit=0.5, \
        loudnorm=I=-14:TP=-1.0:LRA=7" \
        "$output"
    done
done

echo "✅ All files processed! Output saved in '$OUTPUT_DIR'"
