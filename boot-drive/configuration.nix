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
  # networking.firewall.allowedTCPPorts = [ 22 ];

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
    pciutils
    usbutils
    smartmontools
    zfs

    git
    wget
    curl
    dig
    htop
    powertop
    lm_sensors

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
      serviceConfig.Type = "oneshot";
      wants = [ "network-online.target" ];
      wantedBy = [ "default.target" ];
      script = ''
        set -xeuf -o pipefail
        PATH="$PATH:${pkgs.git}/bin"
        export PATH

        git clone --depth=1 https://github.com/Beanow/satactl-vs-hba.git ~/repo
      '';
    };
  };

}
