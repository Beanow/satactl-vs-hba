{
  config,
  modulesPath,
  lib,
  ...
}:

{
  # hardware.enableAllFirmware = true;
  hardware.enableAllHardware = true;
  boot.supportedFilesystems = [ "zfs" ];
}
