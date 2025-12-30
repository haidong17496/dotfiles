{ pkgs, ... }:

{
    # 1. Packages
    home.packages = [ pkgs.bluez ];

    # 2. OBEX Service (Existing config)
    systemd.user.services.obex = {
        Unit = {
            Description = "Bluetooth OBEX service";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
        };

        Service = {
            ExecStart = "${pkgs.bluez}/libexec/bluetooth/obexd --nodetach --root=%h/Downloads";
            Restart = "on-failure";
            Type = "dbus";
            BusName = "org.bluez.obex";
        };

        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
