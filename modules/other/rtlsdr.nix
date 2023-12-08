{pkgs, ...}: {
  users.groups.plugdev =  {};
  boot.blacklistedKernelModules = ["dvb_usb_rtl28xxu"];
  services.udev.packages = [ pkgs.rtl-sdr ];

  users.users.gurki = {
    extraGroups = ["plugdev"];
    packages = with pkgs; [
      gnuradioPackages.osmosdr
      rtl-sdr
      gnuradio
      gqrx
    ];
  };
}