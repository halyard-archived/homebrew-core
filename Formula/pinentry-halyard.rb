class PinentryHalyard < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.0.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.0.0.tar.bz2"
  sha256 "1672c2edc1feb036075b187c0773787b2afd0544f55025c645a71b4c2f79275a"

  depends_on "pkg-config-halyard" => :build
  depends_on "libgpg-error-halyard"
  depends_on "libassuan-halyard"
  depends_on "gtk+-halyard" => :optional

  conflicts_with "pinentry", :because => "pinentry-halyard replaces pinentry"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-pinentry-qt
      --disable-pinentry-qt5
      --disable-pinentry-gnome3
    ]

    args << "--disable-pinentry-gtk2" if build.without? "gtk+"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
  end
end
