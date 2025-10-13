{
  description = "Hugo site for odoom.net";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Paper theme package
        paperTheme = pkgs.fetchFromGitHub {
          owner = "nanxiaobei";
          repo = "hugo-paper";
          rev = "8c75cdd9ce53795675f7a54d431870eeac559665";
          sha256 = "sha256-p/DFAfG6xAMUnKT0kB0wEu7FziDTcP2n//iJ+GZzb/U=";
        };

        # Build the Hugo site
        site = pkgs.stdenv.mkDerivation rec {
          name = "blog-odoom-net";
          src = ./hugo-site;

          buildInputs = [ pkgs.hugo ];

          buildPhase = ''
            mkdir -p themes/paper
            cp -r ${paperTheme}/* themes/paper/
            export NIX_STORE_PATH="$out"
            hugo --minify
          '';

          installPhase = ''
            cp -r public $out
          '';
        };
      in
      {
        packages.default = site;

        apps.default = {
          type = "app";
          program = toString (pkgs.writeShellScript "serve" ''
            # Build a local version with localhost baseURL
            TMPDIR=$(mktemp -d)
            cp -r ${./hugo-site}/* $TMPDIR/
            mkdir -p $TMPDIR/themes/paper
            cp -r ${paperTheme}/* $TMPDIR/themes/paper/
            cd $TMPDIR
            export NIX_STORE_PATH="${site}"
            ${pkgs.hugo}/bin/hugo --baseURL "http://localhost:8000" --minify

            echo "Serving blog.odoom.net locally on http://localhost:8000"
            cd public
            ${pkgs.python3}/bin/python -m http.server 8000
          '');
        };

        apps.deploy = {
          type = "app";
          program = toString (pkgs.writeShellScript "deploy" ''
            set -euo pipefail

            TAG="''${1:-latest}"
            IMAGE="registry.fly.io/blog-odoom-net:$TAG"

            echo "Building and deploying to Fly.io with tag: $TAG"

            # Build the Hugo site with Nix first to get the store path
            echo "Building Hugo site with Nix..."
            STORE_PATH=$(${pkgs.nix}/bin/nix build --no-link --print-out-paths)
            echo "Nix store path: $STORE_PATH"

            # Build Docker image with the Nix store path as a build arg
            ${pkgs.docker}/bin/docker build --platform linux/amd64 \
              --build-arg NIX_STORE_PATH="$STORE_PATH" \
              -t "$IMAGE" ${./.}

            # Push to Fly registry
            ${pkgs.docker}/bin/docker push "$IMAGE"

            # Get digest
            DIGEST=$(${pkgs.docker}/bin/docker inspect "$IMAGE" --format='{{index .RepoDigests 0}}' | cut -d'@' -f2)

            # Deploy to Fly (run from project directory to pick up fly.toml)
            cd ${./.}
            ${pkgs.flyctl}/bin/fly deploy --image "registry.fly.io/blog-odoom-net@$DIGEST"

            echo "Deployment complete!"
          '');
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
            go
            flyctl
          ];

          shellHook = ''
            echo "Hugo dev environment"
            echo "hugo version: $(hugo version)"
            echo ""

            # Clone Paper theme if not exists
            if [ ! -d "hugo-site/themes/paper/.git" ]; then
              echo "Cloning Paper theme..."
              mkdir -p hugo-site/themes
              git clone https://github.com/nanxiaobei/hugo-paper.git hugo-site/themes/paper
            fi

            echo "Starting Hugo server..."
            cd hugo-site && hugo server
          '';
        };
      }
    );
}
