{
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    ./hardware-configuration.nix
  ];

  services.zfs.trim.enable = true;

  time.timeZone = "Europe/Amsterdam";

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "svh-test";
  networking.hostId = "ad354062";
  networking.firewall.allowedTCPPorts = [ 22 ];

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

  environment.systemPackages = with pkgs; [
    wget
    curl
    dig
    htop
    zfs

    fio

    powertop
    lm_sensors
    smartmontools

    prometheus-node-exporter
    prometheus-smartctl-exporter
  ];

  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.smartctl.enable = true;
}
