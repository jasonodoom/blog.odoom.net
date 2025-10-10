{
  description = "Hugo environment for odoom.net";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
            go
          ];

          shellHook = ''
            echo "hugo version: $(hugo version)"
            echo ""

            # Clone Paper theme if not exists
            if [ -d "hugo-site" ] && [ ! -d "hugo-site/themes/paper/.git" ]; then
              mkdir -p hugo-site/themes
              git clone https://github.com/nanxiaobei/hugo-paper.git hugo-site/themes/paper
            fi

            # Auto-start hugo server
            if [ -d "hugo-site" ]; then
              cd hugo-site && hugo server
            fi
          '';
        };
      }
    );
}
