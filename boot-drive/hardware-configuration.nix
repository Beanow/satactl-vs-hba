{
  config,
  modulesPath,
  lib,
  options,
  ...
}:

let
  vdisk = [
    "11"
    "22"
    "33"
    "44"
  ];
  shortId = id: builtins.substring 38 4 id;
  data = import ./data.nix;
in
{
  # hardware.enableAllFirmware = true;
  hardware.enableAllHardware = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.timeout = lib.mkForce 3;

  # Default is very tight, not leaving room for benchmark files.
  virtualisation.diskSize = 8 * 1024;

  fileSystems =
    if !config.virtualisation ? qemu then
      # Directly mounting SSDs with an ext4 partition.
      builtins.listToAttrs (
        map (disk: {
          name = "/mnt/ssd-${disk.group}-${shortId disk.id}-ext4";
          value = {
            device = "/dev/disk/by-id/${disk.id}-part1";
            fsType = "ext4";
            # Allow easy mount/unmount.
            # High chance the drive is reformatted / partitioned.
            # Default performance tradeoff.
            options = [
              "users"
              "nofail"
              "relatime"
            ];
          };
        }) data.disks
      )
    else
      # Similar example directories for local --run
      lib.mkVMOverride (
        builtins.listToAttrs (
          map (x: {
            name = "/mnt/ssd-00${x}-ext4";
            value = {
              fsType = "none";
              device = "/home/beanow/vdev-${x}";
              options = [ "bind" ];
            };
          }) vdisk
        )
      );
}
