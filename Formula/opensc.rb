class OpenscHalyard < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.17.0/opensc-0.17.0.tar.gz"
  sha256 "be73c6816867ab4721e6a9ae7dba8e890c5f169f0a2cbb4bf354e0f30a948300"
  head "https://github.com/OpenSC/OpenSC.git"

  option "without-man-pages", "Skip building manual pages"

  depends_on "autoconf-halyard" => :build
  depends_on "automake-halyard" => :build
  depends_on "libtool-halyard" => :build
  depends_on "pkg-config-halyard" => :build
  depends_on "docbook-xsl-halyard" => :build if build.with? "man-pages"
  depends_on "openssl-halyard"


  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-sm
      --enable-openssl
      --enable-pcsc
    ]

    if build.with? "man-pages"
      args << "--with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end
end
