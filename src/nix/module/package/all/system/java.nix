{ lib, pkgs, system, vars, ... }:
let
  isLinux = lib.hasSuffix "-linux" system;
  jdk = pkgs.graalvmPackages.graalvm-ce;
in
{
  environment.systemPackages = with pkgs; [
    jdk
    maven
  ];

  environment.variables = {
    JAVA_HOME = "${jdk.home}";
    NATIVE_IMAGE_OPTIONS = "-H:NativeLinkerOption=-L${pkgs.zlib}/lib";
  };
} // lib.optionalAttrs (!isLinux) {
  system.activationScripts.postActivation.text = ''
    mkdir -p /Library/Java/JavaVirtualMachines
    ln -sfn ${jdk.home} /Library/Java/JavaVirtualMachines/nix-temurin-25.jdk
  '';
}
