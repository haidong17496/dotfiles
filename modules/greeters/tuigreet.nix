{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "
          ${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --window-padding 1 --greeting 'Hi, mate. Welcome home! ^^'";
        user = "greeter";
      };
    };
  };
}
