class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.57.0.tar.bz2"
  mirror "http://curl.askapache.com/download/curl-7.57.0.tar.bz2"
  sha256 "c92fe31a348eae079121b73884065e600c533493eb50f1f6cee9c48a3f454826"

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_osx

  option "with-libssh2", "Build with scp and sftp support"
  option "with-c-ares", "Build with C-Ares async DNS support"
  option "with-gssapi", "Build with GSSAPI/Kerberos authentication support."
  option "with-nghttp2", "Build with HTTP/2 support (requires OpenSSL)"

  depends_on "openssl"
  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional
  depends_on "c-ares" => :optional
  depends_on "nghttp2" => :optional


  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    # cURL has a new firm desire to find ssl with PKG_CONFIG_PATH instead of using
    # "--with-ssl" any more. "when possible, set the PKG_CONFIG_PATH environment
    # variable instead of using this option". Multi-SSL choice breaks w/o using it.
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl"].opt_lib}/pkgconfig"
    args << "--with-ssl=#{Formula["openssl"].opt_prefix}"
    args << "--with-ca-bundle=#{etc}/openssl/cert.pem"
    args << "--with-ca-path=#{etc}/openssl/certs"

    args << (build.with?("libssh2") ? "--with-libssh2" : "--without-libssh2")

    if build.with? "c-ares"
      args << "--enable-ares=#{Formula["c-ares"].opt_prefix}"
    else
      args << "--disable-ares"
    end

    system "./configure", *args
    system "make", "install"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
