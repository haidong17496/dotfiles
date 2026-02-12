{pkgs, ...}: let
  screen-record = pkgs.writeShellScriptBin "screen-record" ''
    if pgrep -f "gpu-screen-recorder" > /dev/null; then
        pkill -INT -f "gpu-screen-recorder"
    else
        RECORD_DIR="$HOME/Videos/recordings"
        mkdir -p "$RECORD_DIR"
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        TEMP_FILE="$RECORD_DIR/temp_$TIMESTAMP.mp4"
        FINAL_FILE="$RECORD_DIR/rec_$TIMESTAMP.mp4"

        notify-send "Recorder" "Recording started (Auto-Mix Audio)" -i video-display -a "System"

        (
            gpu-screen-recorder \
              -w portal \
              -f 30 \
              -a default_output \
              -a default_input \
              -o "$TEMP_FILE"

            notify-send "Recorder" "Processing audio..." -i video-display -a "System"

            ${pkgs.ffmpeg}/bin/ffmpeg -i "$TEMP_FILE" \
              -filter_complex "[0:a:0][0:a:1]amix=inputs=2:duration=longest[a]" \
              -map 0:v -map "[a]" \
              -c:v copy -c:a aac \
              "$FINAL_FILE"

            rm "$TEMP_FILE"
            notify-send "Recorder" "Recording saved & mixed!" -i video-display -a "System"
        ) &
    fi
  '';
in {
  home.packages = with pkgs; [
    screen-record
  ];
}
