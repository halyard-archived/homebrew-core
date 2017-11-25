class Nghttp2Halyard < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.27.0/nghttp2-1.27.0.tar.xz"
  sha256 "e83819560952a3dc3c8d96c46f60745408f46f5f384168c90b9e3dfa53b2c2c8"

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "automake-halyard" => :build
    depends_on "autoconf-halyard" => :build
    depends_on "libtool-halyard" => :build
  end

  option "with-examples", "Compile and install example programs"
  option "with-python3", "Build python3 bindings"

  depends_on "python3-halyard" => :optional
  depends_on "sphinx-doc-halyard" => :build
  depends_on "pkg-config-halyard" => :build
  depends_on "cunit-halyard" => :build
  depends_on "c-ares-halyard"
  depends_on "libev-halyard"
  depends_on "openssl-halyard"
  depends_on "libevent-halyard"
  depends_on "jansson-halyard"
  depends_on "boost-halyard"
  depends_on "spdylay-halyard"
  depends_on "jemalloc-halyard" => :recommended

  conflicts_with "nghttp2", :because => "nghttp2-halyard replaces nghttp2"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/98/bb/cd2be435e28ee1206151793a528028e3dc9a787fe525049efb73637f52bb/Cython-0.27.2.tar.gz"
    sha256 "265dacf64ed8c0819f4be9355c39beaa13dc2ad2f85237a2c4e478f5ce644b48"
  end

  # https://github.com/tatsuhiro-t/nghttp2/issues/125
  # Upstream requested the issue closed and for users to use gcc instead.
  # Given this will actually build with Clang with cxx11, just use that.
  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --with-boost=#{Formula["boost-halyard"].opt_prefix}
      --enable-asio-lib
      --with-spdylay
      --disable-python-bindings
    ]

    args << "--enable-examples" if build.with? "examples"
    args << "--with-xml-prefix=/usr" if MacOS.version > :lion
    args << "--without-jemalloc" if build.without? "jemalloc"

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"

    # Currently this is not installed by the make install stage.
    if build.with? "docs"
      system "make", "html"
      doc.install Dir["doc/manual/html/*"]
    end

    system "make", "install"
    libexec.install "examples" if build.with? "examples"

    if build.with? "python3"
      pyver = Language::Python.major_minor_version "python3"
      ENV["PYTHONPATH"] = cythonpath = buildpath/"cython/lib/python#{pyver}/site-packages"
      cythonpath.mkpath
      ENV.prepend_create_path "PYTHONPATH", lib/"python#{pyver}/site-packages"

      resource("Cython").stage do
        system "python3", *Language::Python.setup_install_args(buildpath/"cython")
      end

      cd "python" do
        system buildpath/"cython/bin/cython", "nghttp2.pyx"
        system "python3", *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
