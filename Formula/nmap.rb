class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.70.tar.bz2"
  sha256 "847b068955f792f4cc247593aca6dc3dc4aae12976169873247488de147a6e18"

  option "with-pygtk", "Build Zenmap GUI"

  depends_on "openssl"
  depends_on "pygtk" => :optional

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --without-nmap-update
      --disable-universal
    ]

    args << "--without-zenmap" if build.without? "pygtk"

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
