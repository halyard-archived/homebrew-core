class SpdylayHalyard < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"
  revision 1

  depends_on "autoconf-halyard" => :build
  depends_on "automake-halyard" => :build
  depends_on "libtool-halyard" => :build
  depends_on "pkg-config-halyard" => :build
  depends_on "libevent-halyard" => :recommended
  depends_on "libxml2-halyard" if MacOS.version <= :lion
  depends_on "openssl-halyard"

  conflicts_with "spdylay", :because => "spdylay-halyard replaces spdylay"

  def install
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_search_clock_gettime"] = "no"
    end

    if MacOS.version > :lion
      Formula["libxml2-halyard"].stable.stage { (buildpath/"m4").install "libxml.m4" }
    end

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spdycat", "-ns", "https://cloudflare.com/"
  end
end