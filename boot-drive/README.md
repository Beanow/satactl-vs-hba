Running with QEMU locally

```sh
nixos-generate -c boot-drive/configuration.nix --run
```

Generating ISO that can be written to a flash drive

```sh
nixos-generate -c boot-drive/configuration.nix -f iso -o boot-drive/image
```

Warning: rebuilding images a lot will take up significant amount of disk space.
Consider `nix-store --gc` every so often (freed 35GB just now).
