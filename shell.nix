{
  pkgs ? import <nixpkgs> { },
}:

let
  packages = with pkgs; [
    shfmt
    shellcheck
    docker
  ];
in
pkgs.mkShellNoCC {
  inherit packages;
  shellHook = ''
    echo -ne "-----------------------------------\n "
    echo -n "${toString (map (pkg: "• ${pkg.name}\n") packages)}"
    echo "-----------------------------------"
    export DOCKER_HOST="unix:///run/user/$UID/docker.sock"
  '';
}
