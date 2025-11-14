{ config, lib, pkgs, ... }:

{
  # Enable libvirtd for VM management
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  # Enable virt-manager GUI
  programs.virt-manager.enable = true;

  # Enable SPICE USB redirection for better peripheral support
  virtualisation.spiceUSBRedirection.enable = true;

  # Add required packages for VM management and Windows support
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    quickemu
    qemu
    looking-glass-client
    virtio-win
  ];

  # Enable nested virtualization for better performance
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_amd nested=1
  '';

  # Systemd tmpfiles rule for QEMU firmware
  systemd.tmpfiles.rules = [
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
  ];

  # Enable hugepages for better memory performance (optional)
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 2048; # 4GB of hugepages (2MB each)
  };

  # User groups for VM access
  users.groups.libvirtd.members = [ "ham" ];

  # Ensure required services are running
  systemd.services.libvirtd = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };
}