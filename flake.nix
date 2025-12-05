{
    description = "server template";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    outputs = { self, nixpkgs, ... }@inputs: {
        nixosConfigurations = {
            nix-testbed = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    ./hosts/docker-nixos/docker-nixos.nix
                    ./hosts/lxc.nix
                ];
            };
        };
    };
}
