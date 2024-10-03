{
  lib,
  pkg-config,
  pkgs,
  melpaBuild,
  stdenv,
}:

let
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
melpaBuild {
  pname = "gl";
  version = "0-unstable-2024-10-03";

  src = lib.cleanSource ./.;

  ignoreCompilationError = false;

  nativeBuildInputs = [
    pkg-config
    pkgs.python3
    pkgs.libglvnd
    pkgs.cmake
  ];

  buildInputs = [
    pkgs.stb
    pkgs.imgui
    pkgs.glm
    pkgs.python3Packages.glad
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  postBuild = ''
    make
    cp -v $NIX_BUILD_TOP/source/gl-module.so .
  '';

  postInstall = ''
    outd=$out/share/emacs/site-lisp/elpa/gl-$melpaVersion
    install -m755 --target-directory=$outd gl-module${libExt}
  '';

  files = ''(:defaults "gl-module.so")'';

}
