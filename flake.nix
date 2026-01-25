{
    description = "server template";


    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    overlays = {
        unstable-packages = final: _prev: {
            unstable = import inputs.nixpkgs-unstable {
                system = "x86_64-linux";
                config = {
                    allowUnfree = true;
                };
            };
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
        nixosConfigurations = {
            nix-testbed = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    ./hosts/lxc.nix
                ];
            };
            nix-containers = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    ./hosts/docker-nixos/docker-nixos.nix
                    ./hosts/vm.nix
                ];
            };
            nix-dorm-containers = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    ./hosts/nix-dorm-containers/podman-nixos.nix
                    ./hosts/vm.nix
                ];
            };
        };
    };
}
