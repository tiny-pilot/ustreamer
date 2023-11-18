{
  description = "Dev environment for uStreamer";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # 0.11.0
    zig_dep.url = "github:NixOS/nixpkgs/46688f8eb5cd6f1298d873d4d2b9cf245e09e88e";
  };

  outputs = { self, flake-utils, zig_dep }@inputs :
    flake-utils.lib.eachDefaultSystem (system:
    let
      zig_dep = inputs.zig_dep.legacyPackages.${system};
    in
    {
      devShells.default = zig_dep.mkShell {
        packages = [
          zig_dep.alsaLib
          zig_dep.libbsd
          zig_dep.libevent
          zig_dep.libjpeg
          zig_dep.libopus
          zig_dep.glib
          zig_dep.jansson
          zig_dep.janus-gateway
          zig_dep.pkg-config
          zig_dep.python39
          zig_dep.speex
          zig_dep.zig
        ];

        shellHook = ''
          echo "zig" "$(zig version)"
        '';
      };
    });
}
