# Capy Dock — https://docs.capy.ai/dock
#
# `capy dock` is Capy without the desktop app: it pairs a machine to your Capy
# organisation and runs threads on it, driven from the web app or the desktop
# app on another machine. Packaged from the official release archive.
#
# Deliberately NOT autoPatchelfHook. The binary verifies the files beside it
# against a manifest signed into itself (`capy dock verify`), so lib/ has to
# stay byte-for-byte as shipped. Only bin/capy is patched, and the native
# .node modules under lib/ get their libraries through LD_LIBRARY_PATH on the
# wrapper instead of having their own bytes rewritten.
#
# Bump: set `version`, then refresh the hashes from
# https://d1lfowv2t69uz0.cloudfront.net/stable/dock/<version>/SHA256SUMS
# (`nix hash convert --hash-algo sha256 --to sri <hex>`). The newest version is
# at .../stable/dock/latest.
{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  patchelf,
}:
let
  version = "0.9.2";
  base = "https://d1lfowv2t69uz0.cloudfront.net/stable/dock";

  sources = {
    x86_64-linux = {
      target = "linux-x64";
      hash = "sha256-uYRWE7o3xQiJX+9MVsaXXH04qZzH4g2nFg87QSj7v2s=";
    };
    aarch64-linux = {
      target = "linux-arm64";
      hash = "sha256-111kqYShitcnenHfp0XR8mD9Tlhiu2CY/qNkRqa7hzg=";
    };
    aarch64-darwin = {
      target = "darwin-arm64";
      hash = "sha256-6rQjB4bVLWNwXd3SZwQTASNkuzKVxq4eMt4dVJ/R/Fo=";
    };
  };

  inherit (stdenv.hostPlatform) isLinux system;
  src = sources.${system} or (throw "capy-dock: no release for ${system}");

  # Everything the binary and the bundled .node modules link against.
  runtimeLibs = [
    stdenv.cc.cc.lib # libstdc++, libgcc_s
    stdenv.cc.libc # libc, libdl, libm, libpthread, libutil
  ];
in
stdenv.mkDerivation {
  pname = "capy-dock";
  inherit version;

  src = fetchurl {
    url = "${base}/${version}/capy-dock-${src.target}.tar.gz";
    inherit (src) hash;
  };

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals isLinux [ patchelf ];

  dontConfigure = true;
  dontBuild = true;
  # Patching or stripping lib/ would break the signed manifest.
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/bin
    cp -r . $out/libexec/capy-dock
    chmod +x $out/libexec/capy-dock/bin/capy

    ${lib.optionalString isLinux ''
      patchelf --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
        $out/libexec/capy-dock/bin/capy
    ''}

    makeWrapper $out/libexec/capy-dock/bin/capy $out/bin/capy \
      ${lib.optionalString isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}"}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    [ "$($out/bin/capy dock version)" = "${version}" ]
    runHook postInstallCheck
  '';

  meta = {
    description = "Headless Capy device: run agent threads on this machine";
    homepage = "https://capy.ai";
    downloadPage = "https://docs.capy.ai/dock";
    license = lib.licenses.unfree;
    mainProgram = "capy";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
