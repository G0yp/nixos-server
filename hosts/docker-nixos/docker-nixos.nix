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
#        extraPackages = with pkgs; [
#            shadow
#        ];
    };
    users.users.remote = {
        extraGroups = [ "podman" ];
        subUidRanges = [{ startUid = 100000; count = 65536; }];
        subGidRanges = [{ startGid = 100000; count = 65536; }];
    };
    environment.systemPackages = with pkgs; [
        podman-tui
        podman-compose
    ];
#    virtualisation.oci-containers.backend = "podman";
#    virtualisation.oci-containers.containers.dockge = {
#        podman.user = "remote";
#        image = "louislam/dockge:1";
#        autoStart = true;
#        environment = {
#            DOCKGE_STACKS_DIR = "/opt/stacks";
#        };
#        ports = [ "5001:5001" ];
#        volumes = [ 
#            "/opt/stacks:/opt/stacks"
#            "/var/run/docker.sock:/var/run/docker.sock"
#            "/opt/stacks/dockge/data:/app/data"
#        ];
#        # workdir = "/opt/stacks/dockge";
#    };
#    networking.firewall.allowedTCPPorts = [5001];
}
