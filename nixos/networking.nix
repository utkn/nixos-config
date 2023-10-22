{ ... }: {
  networking.hostName = "apollo";
  networking.hostId = "00bab10c";
  # Use NetworkManager
  networking.networkmanager.enable = true;
  # Allow mDNS broadcast + listen
  networking.networkmanager.extraConfig = "
    [connection]
    mdns=2
  ";
  # Disable the firewall.
  networking.firewall.enable = false;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
}