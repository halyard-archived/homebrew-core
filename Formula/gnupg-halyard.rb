class GnupgHalyard < Formula
  desc "GNU Privacy Guard: a free PGP replacement"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.3.tar.bz2"
  sha256 "cbd37105d139f7aa74f92b6f65d136658682094b0e308666b820ae4b984084b4"

  head do
    url "https://dev.gnupg.org/source/gnupg.git"
    depends_on "autoconf-halyard" => :build
    depends_on "automake-halyard" => :build
  end

  depends_on "pkg-config-halyard" => :build
  depends_on "npth-halyard"
  depends_on "gnutls-halyard"
  depends_on "libgpg-error-halyard"
  depends_on "libgcrypt-halyard"
  depends_on "libksba-halyard"
  depends_on "libassuan-halyard"
  depends_on "pinentry-halyard"
  depends_on "gettext-halyard"
  depends_on "adns-halyard"
  depends_on "readline-halyard"
  depends_on "libusb-halyard"

  conflicts_with "gpg-agent", :because => "This GnuPG 2.1 includes gpg-agent"
  conflicts_with "dirmngr", :because => "This GnuPG 2.1 includes dirmngr"
  conflicts_with "gnupg2", :because => "This GnuPG 2.1 includes gnupg2 (duh)"
  conflicts_with "gnupg", :because => "This GnuPG is better than GnuPG1"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sbindir=#{bin}
      --sysconfdir=#{etc}
      --enable-symcryptrun
      --with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry
      --with-readline=#{Formula["readline"].opt_prefix}
      --enable-large-secmem
      --enable-all-tests
    ]

    if build.head?
      args << '--enable-maintainer-mode'
      system './autogen.sh'
      system 'autoconf'
    end
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  test do
    (testpath/"batch.gpg").write <<-EOS.undent
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
