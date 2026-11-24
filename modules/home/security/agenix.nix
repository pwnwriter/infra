{ config, ... }:
{
  age = {
    identityPaths = [
      "${config.xdg.dataHome}/ssh/id_ed25519"
    ];

    secrets = {
      ssh-key = {
        file = ../../../secrets/ssh-key.age;
        path = "${config.xdg.dataHome}/ssh/id_rsa";
      };
      gpg-key = {
        file = ../../../secrets/gpg-key.age;
      };
    };
  };
}
