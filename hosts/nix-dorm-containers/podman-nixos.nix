{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];
    networking.hostName = "nix-dorm-containers";
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
    ];

    networking.firewall.allowedTCPPorts = [25565];
}
