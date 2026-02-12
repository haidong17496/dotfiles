{pkgs, ...}: {
  # ---------------------------------------------------------
  # System Level: Hardware & Drivers
  # ---------------------------------------------------------
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  # ---------------------------------------------------------
  # User Service (Global for all users)
  # ---------------------------------------------------------
  environment.systemPackages = with pkgs; [
    bluez
  ];

  systemd.user.services.obex = {
    description = "Bluetooth OBEX service for file transfer";
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];

    serviceConfig = {
      ExecStart = "${pkgs.bluez}/libexec/bluetooth/obexd --nodetach --root=%h/Downloads";
      Restart = "on-failure";
      Type = "dbus";
      BusName = "org.bluez.obex";
    };

    wantedBy = ["graphical-session.target"];
  };
}
