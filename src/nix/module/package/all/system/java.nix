{ lib, pkgs, system, vars, ... }:
let
  isLinux = lib.hasSuffix "-linux" system;
  jdk = pkgs.javaPackages.compiler.temurin-bin.jdk-25;
in
{
  environment.systemPackages = with pkgs; [
    jdk
    maven
  ];

  environment.variables = {
    JAVA_HOME = "${jdk.home}";
  };
} // lib.optionalAttrs (!isLinux) {
  system.activationScripts.postActivation.text = ''
    mkdir -p /Library/Java/JavaVirtualMachines
    ln -sfn ${jdk.home} /Library/Java/JavaVirtualMachines/nix-temurin-25.jdk
  '';
}
