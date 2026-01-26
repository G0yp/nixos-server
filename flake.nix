{
    description = "server template";


    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        opencode = {
            url = "github:anomalyco/opencode/v1.1.36";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, opencode, ... }@inputs: {
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
                    ({ pkgs, ... }: {
                        environment.systemPackages = [
                            opencode.packages.x86_64-linux.default
                        ];
                    })
                        
                        
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
