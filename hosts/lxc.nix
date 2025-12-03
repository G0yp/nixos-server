{ config, modulesPath, pkgs, lib, ... }:
{
    imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];
    nix.settings = { sandbox = false; };
    proxmoxLXC = {
        manageNetwork = false;
    };
    services.fstrim.enable = false; # Let Proxmox host handle fstrim
}
