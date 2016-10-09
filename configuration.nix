# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;

    google-chrome = {
      enablePepperFlash = true;
    };
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  # 4.7 kernel for backlit keyboard
  boot.kernelPackages = pkgs.linuxPackages_4_7;

  security.grsecurity.enable = true;

  networking = {
    hostName = "delly"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    extraHosts = "127.0.0.1 delly";
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        # KDE Connect
        { from = 1714; to = 1764; }
      ];
      allowedUDPPortRanges = [
        # Chromecast
        { from = 32768; to = 61000; }
        # KDE Connect
        { from = 1714; to = 1764; }
      ];
    };
  };

  powerManagement.enable = true;

  hardware = {
    bluetooth.enable = true;
    opengl.enable = true;
    opengl.driSupport32Bit = true;
    opengl.extraPackages = [ pkgs.vaapiIntel ];
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  programs.zsh.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    apacheKafka
    dpkg
    gcc
    gensgs
    geoclue2
    git
    google-chrome
    kde5.okular
    kdeconnect
    mupen64plus
    nwjs_0_12
    openttd
    pciutils
    riak
    rfkill
    snes9x-gtk
    spotify
    steam
    vim
    wget
    which
    wine
    yakuake
  ];

  fonts = {
    fonts = with pkgs; [
      source-code-pro
    ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.tlp.enable = true;

  # services.redshift.enable = true;
  # services.redshift.latitude = "41.0";
  # services.redshift.longitude = "-74.0";
  # services.redshift.temperature.night = 2300;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbModel = "chromebook";

  # Enable touchpad
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.kde5.enable = true;

  # 7 databases in 7 weeks?
  # 7 databases in 7 lines
  services.postgresql.enable = true;
  # services.riak.enable = true;
  services.hbase.enable = true;
  services.mongodb.enable = true;
  services.couchdb.enable = true;
  services.neo4j.enable = true;
  services.redis.enable = true;

  # services.zookeeper.enable = true;
  # virtualisation.docker.enable = true;
  # virtualisation.virtualbox.host.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.chris = {
    isNormalUser = true;
    home = "/home/chris";
    description = "Chris";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";
}
