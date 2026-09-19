{
  description = "OpenGL bindings for Emacs Lisp (dynamic module for the GLArea xwidget feature)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems
          (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            cmake
            gcc
            pkg-config
            python3

            # C/C++ dependencies consumed by CMake
            imgui        # >= 1.91, provides imgui::imgui CMake config
            glm          # provides glm::glm CMake config
            stb          # header-only
            libGL        # OpenGL + GLX
            libx11
            libxext
          ];

          shellHook = ''
            echo "emacs-gl dev shell"
            echo "  ./gen-glad.sh build/glad   # generate OpenGL loader"
            echo "  cmake -S . -B build && cmake --build build"
          '';
        };
      });
    };
}
