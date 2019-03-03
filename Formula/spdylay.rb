class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl"

  def install
    if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_search_clock_gettime"] = "no"
    end

    Formula["libxml2"].stable.stage { (buildpath/"m4").install "libxml.m4" }

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Check here for popular websites using SPDY:
    # https://w3techs.com/technologies/details/ce-spdy/all/all
    system "#{bin}/spdycat", "-ns", "https://www.twitter.com/"
  end
end
