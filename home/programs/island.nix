{pkgs, ...}: let
  dynamic-island = pkgs.callPackage ../widgets/package.nix {};
in {
  # 1. Install the binary
  home.packages = [dynamic-island];

  systemd.user.services.dynamic-island = {
    Unit = {
      Description = "Dynamic Island Widget";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${dynamic-island}/bin/dynamic-island";
      Restart = "always";
      RestartSec = "5";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
