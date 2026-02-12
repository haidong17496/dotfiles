{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "haidong17496";
    userEmail = "haidong17496@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
