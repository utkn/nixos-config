{ ... }: {
  # Enable networking
  networking.hostName = "apollo";
  networking.networkmanager.enable = true;
  networking.networkmanager.extraConfig = "
    [connection]
    mdns=2
  ";
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}