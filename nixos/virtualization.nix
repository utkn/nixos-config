{ pkgs, adminUser, ... }: {
  # Virtualization kernel options
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
  boot.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # Enable libvirt
  virtualisation.libvirtd.enable = true;

  # Not very secure but it works
  virtualisation.spiceUSBRedirection.enable = true;

  # Enable QEMU support
  virtualisation.libvirtd.qemu = {
    runAsRoot = true;
    swtpm.enable = true;
    ovmf = {
      enable = true;
      # Enable secureboot and tpm support, which is needed for Win11 guests
      packages = [(pkgs.OVMFFull.override {
        secureBoot = true;
        tpmSupport = true;
      }).fd];
    };
  };
  users.groups.libvirtd.members = [ "${adminUser}" ];
  users.groups.kvm.members = [ "${adminUser}" ];

  # Virt-manager requires dconf
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    virtiofsd # File system sharing (do not forget to set the path in vm xml)
    virt-viewer
    podman-compose
  ];

  # Enable podman for containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    # Required for containers under podman-compose to be able to communicate.
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.sessionVariables = {
    PODMAN_COMPOSE_PROVIDER = "podman";
  };
}