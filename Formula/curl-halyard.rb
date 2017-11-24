class CurlHalyard < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.56.1.tar.bz2"
  mirror "http://curl.askapache.com/download/curl-7.56.1.tar.bz2"
  sha256 "2594670367875e7d87b0f129b5e4690150780884d90244ba0fe3e74a778b5f90"

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf-halyard" => :build
    depends_on "automake-halyard" => :build
    depends_on "libtool-halyard" => :build
  end

  keg_only :provided_by_osx

  option "with-libssh2", "Build with scp and sftp support"
  option "with-c-ares", "Build with C-Ares async DNS support"
  option "with-gssapi", "Build with GSSAPI/Kerberos authentication support."
  option "with-nghttp2", "Build with HTTP/2 support (requires OpenSSL)"

  depends_on "openssl-halyard"
  depends_on "pkg-config-halyard" => :build
  depends_on "libssh2-halyard" => :optional
  depends_on "c-ares-halyard" => :optional
  depends_on "nghttp2-halyard" => :optional

  conflicts_with "curl", :because => "curl-halyard replaces curl"

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
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl-halyard"].opt_lib}/pkgconfig"
    args << "--with-ssl=#{Formula["openssl-halyard"].opt_prefix}"
    args << "--with-ca-bundle=#{etc}/openssl/cert.pem"
    args << "--with-ca-path=#{etc}/openssl/certs"

    args << (build.with?("libssh2") ? "--with-libssh2" : "--without-libssh2")

    if build.with? "c-ares"
      args << "--enable-ares=#{Formula["c-ares-halyard"].opt_prefix}"
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