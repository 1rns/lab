{ pkgs, config, lib, ... }:
{
  services = {
    getty.autologinUser = "root";

    nginx = {
      enable = true;

      virtualHosts.localhost.locations."/" = {
        index = "index.html";

        root = "/var/www";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  virtualisation.forwardPorts = [
    { from = "host"; guest.port = 80; host.port = 8080; }
  ];

  system.stateVersion = "23.11";
}
