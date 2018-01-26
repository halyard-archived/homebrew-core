class Openssh < Formula
  desc "SSH client and server"
  homepage "http://www.openssh.com/"
  version "7.6p1"
  url "http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-#{version}.tar.gz"
  sha256 "a323caeeddfe145baaa0db16e98d784b1fbc7dd436a6bf1f479dfd5cd1d21723"
  revision 1

  depends_on "autoconf" => :build
  depends_on "openssl@1.0"
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build


  patch do
    url "https://gist.githubusercontent.com/akerl/689a443754e8046a7793da894787a5ca/raw/8c1496c264d551f8306f6fa3217be3981696ed5b/gistfile1.txt"
    sha256 "0963bcaeabfc8a1b8db7de1a0901725b7e18d7d807a7ee211b963e4cf34d4b91"
  end

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__"

    args = %W[
      --with-libedit
      --with-pam
      --with-kerberos5
      --prefix=#{prefix}
      --sysconfdir=#{etc}/ssh
      --with-ssl-dir=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-ldns" if build.with? "ldns"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ssh", "--version"
  end
end
