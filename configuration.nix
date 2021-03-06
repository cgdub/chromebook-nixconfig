# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # fixed unstable channel builds
  nix.useSandbox = true;

  nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enablePepperFlash = true;
    };

    firefox = {
      # enableAdobeFlash = true;
    };

    packageOverrides = pkgs: {
      _hbase = with pkgs; hbase.overrideDerivation (oldAttrs: rec {
        installPhase = ''
          mkdir -p $out
          cp -R * $out
          wrapProgram $out/bin/hbase --set JAVA_HOME ${jre}
          wrapProgram $out/bin/hbase-daemon.sh \
            --set JAVA_HOME ${jre} \
            --set HBASE_LOG_DIR = /var/log/hbase \
        '';
      });
    };
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  # boot.kernelModules = [ "snd-aloop" "snd-rawmidi" "snd-seq" ];
  # 4.7 kernel for backlit keyboard
  # boot.kernelPackages = pkgs.linuxPackages_4_8;
  boot.kernelPackages = pkgs.linuxPackages_4_11;

  # security.grsecurity.enable = true;
  # get unity3d to work
  security.chromiumSuidSandbox.enable = true;

  networking = {
    hostName = "delly"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    # extraHosts = "127.0.0.1 delly";
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        # KDE Connect
        { from = 1714; to = 1764; }
        # Steam Link
        { from = 27036; to = 27037; }
        # Figwheel
        { from = 3449; to = 3449; }
      ];
      allowedUDPPortRanges = [
        # Chromecast
        { from = 32768; to = 61000; }
        # KDE Connect
        { from = 1714; to = 1764; }
        # Steam Link
        { from = 27031; to = 27036; }
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
    # android-studio
    # apacheKafka
    # bitwig-studio
    bluez-tools
    # discord
    dpkg
    firefox
    fish
    # geoclue2 # for kdeconnect
    git
    # gnome3.pomodoro
    chromium
    # _hbase
    idea.idea-community
    # idea.pycharm-community
    # jack2Full
    # kde5.okular
    # kdeconnect
    lighttable
    mupen64plus
    openttd
    # pavucontrol
    pciutils
    # qjackctl
    quassel
    redshift
    rfkill
    slack
    snes9x-gtk
    # sublime3
    spotify
    steam
    traceroute
    # unity3d
    # ut2004demo
    vim
    wget
    which
    # wine
    xvfb_run
    # yakuake
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
  services.printing.enable = true;

  services.tlp.enable = true;

  # services.redshift.enable = false;
  # services.redshift.latitude = "41.0";
  # services.redshift.longitude = "-74.0";
  # services.redshift.temperature.night = 2000;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbModel = "chromebook";
  # NOTE: In KDE, disable
  # Settings -> Hardward -> Keyboard -> Advanced -> "Configure keyboard options"
  services.xserver.xkbOptions = "ctrl:ralt_rctrl,ctrl:rctrl_ralt,ctrl:swap_lalt_lctl";

  # Enable touchpad
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # 7 databases in 7 weeks?
  # 7 databases in 7 lines
  # services.postgresql.enable = true;
  # services.hbase.enable = true;
  # services.zookeeper.enable = true;
  # services.mongodb.enable = true;
  # services.couchdb.enable = true;
  # services.neo4j.enable = true;
  # services.redis.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.chris = {
    isNormalUser = true;
    home = "/home/chris";
    description = "Chris";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";
}
