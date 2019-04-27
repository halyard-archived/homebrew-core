class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://ipmitool.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.18/ipmitool-1.8.18.tar.bz2"
  sha256 "0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01"

  depends_on "openssl"

  # https://sourceforge.net/p/ipmitool/bugs/433/#89ea and
  # https://sourceforge.net/p/ipmitool/bugs/436/ (prematurely closed):
  # Fix segfault when prompting for password
  # Re-reported 12 July 2017 https://sourceforge.net/p/ipmitool/mailman/message/35942072/
  patch do
    url "https://gist.githubusercontent.com/adaugherity/87f1466b3c93d5aed205a636169d1c58/raw/29880afac214c1821e34479dad50dca58a0951ef/ipmitool-getpass-segfault.patch"
    sha256 "fc1cff11aa4af974a3be191857baeaf5753d853024923b55c720eac56f424038"
  end

  %W[
    b57487e360916ab3eaa50aa6d021c73b6337a4a0 43d210808a1c3a976da3f928e3e43dd8aa4aabfb5d9a0fb7074316976ed51408
    77fe5635037ebaf411cae46cf5045ca819b5c145 fbc505947cdf45b77f436f2e9b78edb93f3a9208d7da70df91a05141283c211a
    f004b4b7197fc83e7d47ec8cbcaefffa9a922717 1e8b918ca8e82ba324c845bfa69b199d16a973952a39f10d359c1821578298e7
    1664902525a1c3771b4d8b3ccab7ea1ba6b2bdd1 808ecbdb45e073c1ed07a64fa9e1ddc931dce709da59b96cec3394958be9aa0d
    a8862d7508fb138b1c286eea958700cca63c9476 1a0da3f34ff623cb3afc95a452d0b7f97b23c9818700602c519a57c8cdaa373e
  ].each_slice(2) do |patch_commit, patch_checksum|
    patch do
      url "https://github.com/ipmitool/ipmitool/commit/#{patch_commit}.patch"
      sha256 patch_checksum
    end
  end

  def install
    # Fix ipmi_cfgp.c:33:10: fatal error: 'malloc.h' file not found
    # Upstream issue from 8 Nov 2016 https://sourceforge.net/p/ipmitool/bugs/474/
    inreplace "lib/ipmi_cfgp.c", "#include <malloc.h>", ""

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-intf-usb
    ]
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
