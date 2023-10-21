{ ... }: {
  # Virtualization
  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf.enable = true;
    };
  };
}