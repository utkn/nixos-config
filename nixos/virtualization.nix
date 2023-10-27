{ pkgs, adminUser, ... }: {
  # Virtualization
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
  boot.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.qemu = {
    runAsRoot = true;
    swtpm.enable = true;
    ovmf = {
      enable = true;
      # Enable secureboot and tpm support for win11 guests
      packages = [(pkgs.OVMFFull.override {
        secureBoot = true;
        tpmSupport = true;
      }).fd];
    };
  };
  users.groups.libvirtd.members = [ "${adminUser}" ];
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    virtiofsd # file system sharing
    virt-viewer
  ];
}