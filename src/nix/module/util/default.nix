{ vars }:
{
  mkCifsMount = import ./mkCifsMount.nix { inherit vars; };
  mkFileWithSecrets = import ./mkFileWithSecrets.nix { inherit vars; };
  mkNfsMount = import ./mkNfsMount.nix { inherit vars; };
  mkUserQuadlets = import ./mkUserQuadlets.nix { inherit vars; };
}
