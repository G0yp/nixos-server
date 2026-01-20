{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];
    networking.hostName = "nix-containers";
    virtualisation.podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
    };
    users.users.remote = {
        extraGroups = [ "podman" ];
        linger = true;
        subUidRanges = [{ startUid = 100000; count = 65536; }];
        subGidRanges = [{ startGid = 100000; count = 65536; }];
    };
    environment.systemPackages = with pkgs; [
        podman-tui
        podman-compose
        podlet
    ];

    networking.firewall.allowedTCPPorts = [3000 5001 5002 5003 5004];

    fileSystems."/mnt/proxmox-share" = {
        device = "//192.168.2.14/proxmox-smb";
        fsType = "cifs";
        options = [ "username=proxmox-smb" "password=Xsv4VNXkqwQ3SCjd" "x-systemd.automount" "noauto" "uid=1000" "gid=100" ];
    };
}
