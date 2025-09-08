{
  disko.devices.disk = {
    disk0 = {
      type = "disk";
      device = "dev/vda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            label = "BOOT";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=077" ];
            };
          };
          luks = {
            size = "100%";
            label = "CRYPT";
            content = {
              type = "luks";
              name = "crypt";
              passwordFile = "/tmp/disko-password";
              extraOpenArgs = [ ];
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "lvm-pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
  };
  disko.devices.lvm_vg = {
    pool = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "12G";
          label = "SWAP";
          content = {
            type = "swap";
            discardPolicy = "both";
            resumeDevice = true;
          };
        };
        fs = {
          type = "btrfs";
          label = "FS";
          extraArgs = [ "-f" ];
          subvolumes = {
            "@" = {
              mountpoint = "/";
              mountOptions = [ "compress=zstd" ];
            };
            "@home" = {
              mountpoint = "/home";
              mountOptions = [ "compress=zstd" ];
            };
            "@persist" = {
              mountpoint = "/persist";
              mountOptions = [ "compress=zstd" "noatime" ];
            };
            "@nix" = {
              mountpoint = "/nix";
              mountOptions = [ "compress=zstd" "noatime" ];
            };
            "@log" = {
              mountpoint = "/var/log";
              mountOptions = [ "compress=zstd" ];
            };
          };
        };
      };
    };
  };
}
