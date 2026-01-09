{ config, modulesPath, pkgs, lib, ... }:
{
    security.pam.services.sshd.allowNullPassword = false;
    services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
            PermitRootLogin = "yes";
            PasswordAuthentication = false;
        };
    };
    networking.firewall.allowedTCPPorts = [22];
    networking.firewall.enable = true;
# Cache DNS lookups to improve performance
    services.resolved = {
        extraConfig = ''
            Cache=true
            CacheFromLocalhost=true
            '';
    };
    time.timeZone = "America/Chicago";
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;
    users.users = {
        root = {
            shell = pkgs.bash;
        };
        remote = {
            shell = pkgs.zsh;
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICr3zofLys716ODhe1HCEdHIWi//qgac+0vZOirsnJGC jake palmer@DJDPB94"
                "ssh0ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEtQLCWU+XlfiaHQ0w8j9vDdCk0wS6+FwwkWuRC8BUPp goupsoup2@gmail.com"
            ];
            extraGroups = ["wheel"];
            isNormalUser = true;
            enable = true;
            packages = with pkgs; [
                    eza
                    tealdeer
            ];
        };
    };
    system.stateVersion = "25.05";
    environment.systemPackages = with pkgs; [
        vim
            git
            btop
            tree
            ripgrep
    ];
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        setOptions = [
            "SHARE_HISTORY"
                "HIST_EXPIRE_DUPS_FIRST"
                "EXTENDED_HISTORY"
        ];
        shellAliases = {
            cd = "z";
            ls = "eza";
            nrs = "sudo nixos-rebuild switch";

        };
    };
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };
    programs.bat.enable = true;
    services.tailscale = {
        enable = true;
    };
}
