{ vars }:
{
  mkCifsMount = import ./mkCifsMount.nix { inherit vars; };
  mkDefaultMounts = import ./mkDefaultMounts { inherit vars; };
  mkFileWithSecrets = import ./mkFileWithSecrets.nix { inherit vars; };
  mkGpuAvailabilityService = import ./mkGpuAvailabilityService.nix;
  mkNfsMount = import ./mkNfsMount.nix { inherit vars; };
  mkSignedApp = import ./mkSignedApp.nix { inherit vars; };
  mkTcpAvailabilityService = import ./mkTcpAvailabilityService.nix;
  mkUserQuadlets = import ./mkUserQuadlets.nix { inherit vars; };
}
