{
  description = "Rescile project execution template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.awscli2
          pkgs.pulumi

          (pkgs.python3.withPackages (ps: [
            ps.boto3
            ps.botocore
            ps.pulumi
            ps.pulumi-aws
            ps.gql       # <-- Dynamic GraphRAG client library added
            ps.requests  # <-- HTTP Transport layer dependency added
          ]))
        ];

        shellHook = ''
            echo "☁️ Python SDK & Pulumi Execution Layer Loaded"
            echo "Python version: $(python --version)"

            export AWS_DEFAULT_REGION="eu-central-2"

            # 1. Automate local state login
            export PULUMI_BACKEND_URL="file://~"
            pulumi login --local > /dev/null 2>&1

            # 2. Automate the encryption passphrase
            if [ -z "$PULUMI_CONFIG_PASSPHRASE" ]; then
            export PULUMI_CONFIG_PASSPHRASE="local-dev-rescile-secret-key"
            fi

            # (.venv setup removed - Nix handles the environment cleanly now)
        '';
      };
    };
}
