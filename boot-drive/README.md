Running with QEMU locally

```sh
nixos-generate -c boot-drive/configuration.nix --run
```

Generating ISO that can be written to a flash drive

```sh
nixos-generate -c boot-drive/configuration.nix -f iso -o boot-drive/image
```
