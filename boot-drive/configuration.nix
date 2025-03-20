{
  config,
  lib,
  pkgs,
  ...
}:

let
  onlineCheck = import ./utils/online.nix {
    internetEndpoint = "github.com";
    exitCode = "1";
    inherit pkgs;
  };
in
{

  imports = [
    ./hardware-configuration.nix
  ];

  services.zfs.trim.enable = true;
  services.hardware.bolt.enable = true;

  time.timeZone = "Europe/Amsterdam";

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "svh-test";
  networking.hostId = "ad354062";

  users.users = {
    beanow = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbQcW/mdDNNNRuoFm2fmO6HpuD6KTSPqvhRVEJrktZa beanow@mjdesktop"
      ];
      extraGroups = [
        "wheel"
        "plugdev"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.sshd.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;
  services.getty.autologinUser = lib.mkDefault "beanow";

  system.stateVersion = "25.05";
  environment.systemPackages = with pkgs; [
    pciutils
    dmidecode
    usbutils
    smartmontools
    zfs
    util-linux
    sysstat

    git
    wget
    curl
    dig
    iputils
    vim
    htop
    powertop
    lm_sensors
    bolt
    thunderbolt

    ulid
    fio

    prometheus-node-exporter
    prometheus-smartctl-exporter
  ];

  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.node.openFirewall = true;
  services.prometheus.exporters.smartctl.enable = true;
  services.prometheus.exporters.smartctl.openFirewall = true;

  systemd.user.services = {
    "clone-on-boot" = {
      wants = [
        "network.target"
        "network-online.target"
      ];
      wantedBy = [ "default.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        set -xeu -o noglob -o pipefail

        PATH="$PATH:${pkgs.git}/bin"
        export PATH

        ${onlineCheck}

        [[ ! -d ~/repo ]] && git clone https://github.com/Beanow/satactl-vs-hba.git ~/repo
        pushd ~/repo
        git pull
        popd
      '';
    };
  };

  # Always authorize USB4 - PCIe tunneling
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
  '';

}
