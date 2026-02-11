{pkgs, ...}: let
  screen-record = pkgs.writeShellScriptBin "screen-record" ''
    if pgrep -x "gpu-screen-recorder" > /dev/null; then
        # Stop recording safely
        pkill -INT gpu-screen-recorder
        notify-send "Recorder" "Recording saved." -i video-display -a "System"
    else
        # Setup directory
        RECORD_DIR="$HOME/Videos/recordings"
        mkdir -p "$RECORD_DIR"
        FILEPATH="$RECORD_DIR/rec_$(date +%Y%m%d_%H%M%S).mp4"

        notify-send "Recorder" "Select region to start..." -i video-display -a "System"

        # -w portal: Select window/region using Hyprland native picker
        # -f 30: 30FPS (Stable for i5-6200U)
        # -a default_output: System Sound
        # -a default_input: Raw Mic
        # No extra quality flags -> Let the tool decide the best defaults
        gpu-screen-recorder \
          -w portal \
          -f 30 \
          -a default_output \
          -a default_input \
          -o "$FILEPATH" &

        notify-send "Recorder" "Recording started!" -i video-display -a "System"
    fi
  '';
in {
  home.packages = with pkgs; [
    screen-record
  ];
}
