{
  pkgs ? import <nixpkgs> { },
}:

let
  pkgInputs = with pkgs; [ shfmt shellcheck ];
in
pkgs.mkShell {
  packages = pkgInputs;

  shellHook = ''
    echo -ne "-----------------------------------\n "
    echo -n "${toString (map (pkg: "• ${pkg.name}\n") pkgInputs)}"
    echo "-----------------------------------"
  '';
}
