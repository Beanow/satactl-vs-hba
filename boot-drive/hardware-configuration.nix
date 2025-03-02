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
  disks = [
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_174509803535";
      group = "A1";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_171661421212";
      group = "A1";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_174132803236";
      group = "A1";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_174132803391";
      group = "A1";
    }

    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_173863423834";
      group = "A2";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_171661421801";
      group = "A2";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_171658420592";
      group = "A2";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_173865423252";
      group = "A2";
    }

    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_174132801021";
      group = "B1";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_173865420985";
      group = "B1";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_174132801538";
      group = "B1";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_173038802816";
      group = "B1";
    }

    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_171658420452";
      group = "B2";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_174132801540";
      group = "B2";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_174132804006";
      group = "B2";
    }
    {
      id = "ata-SanDisk_SD8SB8U-128G-1006_173865420365";
      group = "B2";
    }
  ];
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
        }) disks
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
