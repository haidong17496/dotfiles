{pkgs, ...}: let
  nirishot = pkgs.writeShellScriptBin "nirishot" ''
    # --- Dependencies ---
    GRIM="${pkgs.grim}/bin/grim"
    SLURP="${pkgs.slurp}/bin/slurp"
    WL_COPY="${pkgs.wl-clipboard}/bin/wl-copy"
    NOTIFY="${pkgs.libnotify}/bin/notify-send"
    JQ="${pkgs.jq}/bin/jq"

    # --- Variables ---
    XDG_PICTURES_DIR="$HOME/Pictures"
    if [ -f "$HOME/.config/user-dirs.dirs" ]; then
      source "$HOME/.config/user-dirs.dirs"
    fi

    SAVEDIR="''${XDG_PICTURES_DIR}/screenshots"
    mkdir -p "$SAVEDIR"

    FILENAME="$(date +'%Y-%m-%d-%H%M%S_nirishot.png')"
    FILEPATH="$SAVEDIR/$FILENAME"

    # Defaults
    MODE="region"
    CLIPBOARD_ONLY=0

    # --- Argument Parsing ---
    while [[ $# -gt 0 ]]; do
      case $1 in
        -m|--mode)
          MODE="$2"
          shift; shift ;;
        --clipboard-only)
          CLIPBOARD_ONLY=1
          shift ;;
        *)
          shift ;;
      esac
    done

    # --- Logic ---
    if [[ "$MODE" == "region" ]]; then
        GEOMETRY=$($SLURP)
        if [ -z "$GEOMETRY" ]; then exit 1; fi

        # Capture logic for region
        if [ "$CLIPBOARD_ONLY" -eq 1 ]; then
            $GRIM -g "$GEOMETRY" - | $WL_COPY
            $NOTIFY "Nirishot" "Region copied to clipboard" -i camera-photo
        else
            $GRIM -g "$GEOMETRY" "$FILEPATH"
            $WL_COPY < "$FILEPATH"
            $NOTIFY "Nirishot" "Saved: $(basename "$FILEPATH")" -i "$FILEPATH"
        fi

    elif [[ "$MODE" == "window" ]]; then
        ACTIVE_OUTPUT=$(niri msg -j workspaces | $JQ -r 'first(.[] | select(.is_focused) | .output)')

        if [ -z "$ACTIVE_OUTPUT" ] || [ "$ACTIVE_OUTPUT" == "null" ]; then
            echo "Could not detect active output, capturing entire screen."
            CAPTURE_CMD="$GRIM"
        else
            CAPTURE_CMD="$GRIM -o $ACTIVE_OUTPUT"
        fi

        if [ "$CLIPBOARD_ONLY" -eq 1 ]; then
            $CAPTURE_CMD - | $WL_COPY
            $NOTIFY "Nirishot" "Fullscreen copied to clipboard" -i video-display
        else
            $CAPTURE_CMD "$FILEPATH"
            $WL_COPY < "$FILEPATH"
            $NOTIFY "Nirishot" "Saved: $(basename "$FILEPATH")" -i "$FILEPATH"
        fi
    else
        echo "Usage: nirishot -m [region|window] [--clipboard-only]"
        exit 1
    fi
  '';
in {
  home.packages = with pkgs; [
    nirishot
  ];
}
