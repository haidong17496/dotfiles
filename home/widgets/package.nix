{
  lib,
  rustPlatform,
  pkg-config,
  makeWrapper,
  wayland,
  wayland-protocols,
  libxkbcommon,
  vulkan-loader,
  dbus,
  fontconfig,
  libnotify,
  pulseaudio,
  libglvnd,
  xorg,
}:
rustPlatform.buildRustPackage {
  pname = "dynamic-island";
  version = "0.1.0";

  # The source is the current directory (home/widgets)
  src = ./.;

  # Use the existing Cargo.lock file
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  # Build time tools
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # Runtime dependencies
  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    vulkan-loader
    dbus
    fontconfig
    libnotify
    pulseaudio
    libglvnd
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];

  # Fix for "Shared object not found" errors common with Iced/Wayland/Rust
  postInstall = ''
    wrapProgram $out/bin/dynamic-island \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
      wayland
      libxkbcommon
      vulkan-loader
      libglvnd
      dbus
      fontconfig
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
    ]}"
  '';

  meta = {
    description = "Hyprland Dynamic Island Widget";
    license = lib.licenses.mit;
    mainProgram = "dynamic-island";
  };
}
