# T3 Code server — https://github.com/pingdotgg/t3code
#
# The headless server ("t3 serve") that runs coding agents on a machine and
# serves the web/mobile/desktop clients. Packaged from the official release
# tarball: a bundled Node binary plus its client assets, so nothing is built
# from source. nixpkgs has a `t3code` too, but that builds the Electron
# desktop app and lags upstream, which matters here (see below).
#
# IMPORTANT — keep `version` in step with the apps you connect from.
# Client and server must speak the same orchestration protocol; a mismatch is
# refused outright rather than degraded. The phone and desktop apps update
# themselves, so when one of them moves, this has to move with it.
#
# Bump: set `version`, then refresh the hashes from the release's SHA256SUMS
# asset (`nix hash convert --hash-algo sha256 --to sri <hex>`).
# `t3 update` cannot work here: the store is read-only. Rebuild instead.
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
let
  version = "0.1.2";

  sources = {
    x86_64-linux = {
      asset = "t3-${version}-linux-x64.tar.gz";
      hash = "sha256-eu1iXLlhk43xdMGgZ8DwUjU2CUC1PogqFkMSa3VNoWw=";
    };
    aarch64-linux = {
      asset = "t3-${version}-linux-arm64.tar.gz";
      hash = "sha256-3xEuHxl3K0BVooyXsDLrbQONXXGCAV8cr9MlStb6vQ8=";
    };
    aarch64-darwin = {
      asset = "t3-${version}-darwin-arm64.tar.gz";
      hash = "sha256-mTt1/yW1qRSvGPpOLNE/Icd4bFlBTvJ3TU5wJoTC0c8=";
    };
  };

  inherit (stdenv.hostPlatform) system;
  src = sources.${system} or (throw "t3code: no prebuilt server for ${system}");
in
stdenv.mkDerivation {
  pname = "t3code";
  inherit version;

  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/${src.asset}";
    inherit (src) hash;
  };

  # The `t3` binary and the resource monitor are prebuilt ELFs that want
  # /lib64/ld-linux-x86-64.so.2. They need nothing beyond the C++ runtime:
  # libatomic, libdl, libm, libstdc++, libgcc_s, libpthread, libc.
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontConfigure = true;
  dontBuild = true;

  # The server resolves its client assets and node_modules relative to its own
  # real path, so the tree is kept whole in libexec and only linked into bin.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec/t3code $out/bin
    cp -r . $out/libexec/t3code/
    chmod +x $out/libexec/t3code/t3
    ln -s $out/libexec/t3code/t3 $out/bin/t3
    runHook postInstall
  '';

  meta = {
    description = "Open-source control plane for coding agents (headless server)";
    homepage = "https://t3.codes";
    changelog = "https://github.com/pingdotgg/t3code/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "t3";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
