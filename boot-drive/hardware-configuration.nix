{
  config,
  modulesPath,
  lib,
  ...
}:

{
  # hardware.enableAllFirmware = true;

  boot.kernelParams = [ "console=tty0" ];
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.timeout = 5;

  boot.supportedFilesystems = [ "zfs" ];

  # boot.loader.systemd-boot.enable = true;

  boot.initrd.kernelModules = [
    "amdgpu"
    # "kvm-intel"
    # "virtio_balloon"
    # "virtio_console"
    # "virtio_rng"
  ];

  # boot.extraModulePackages = [
  #   config.boot.kernelPackages.broadcom_sta
  # ];

  # boot.initrd.availableKernelModules = [
  #   "9p"
  #   "9pnet_virtio"
  #   "ata_piix"
  #   "nvme"
  #   "sr_mod"
  #   "uhci_hcd"
  #   "virtio_blk"
  #   "virtio_mmio"
  #   "virtio_net"
  #   "virtio_pci"
  #   "virtio_scsi"
  #   "xhci_pci"
  # ];

}
