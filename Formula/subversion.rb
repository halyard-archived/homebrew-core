class Subversion < Formula
  desc "Version control system designed to be a better CVS"
  homepage "https://subversion.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=subversion/subversion-1.10.0.tar.bz2"
  sha256 "2cf23f3abb837dea0585a6b0ebd70e80e01f95bddef7c1aa097c18e3eaa6b584"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "apr-util"
  depends_on "apr"

  # Always build against Homebrew versions instead of system versions for consistency.
  depends_on "lz4"
  depends_on "sqlite"
  depends_on "utf8proc"

  # For Serf
  depends_on "scons" => :build
  depends_on "openssl"

  resource "serf" do
    url "https://www.apache.org/dyn/closer.cgi?path=serf/serf-1.3.9.tar.bz2"
    mirror "https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2"
    sha256 "549c2d21c577a8a9c0450facb5cca809f26591f048e466552240947bdf7a87cc"
  end

  def install
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/2.7/bin"

    serf_prefix = libexec/"serf"

    resource("serf").stage do
      # scons ignores our compiler and flags unless explicitly passed
      args = %W[
        PREFIX=#{serf_prefix} GSSAPI=/usr CC=#{ENV.cc}
        CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}
        OPENSSL=#{Formula["openssl"].opt_prefix}
        APR=#{Formula["apr"].opt_prefix}
        APU=#{Formula["apr-util"].opt_prefix}
      ]
      scons(*args)
      scons "install"
    end

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --enable-optimize
      --with-zlib=/usr
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-apr-util=#{Formula["apr-util"].opt_prefix}
      --with-apxs=no
      --with-serf=#{serf_prefix}
      --disable-mod-activation
      --without-apache-libexecdir
      --without-berkeley-db
    ]

    args << "--without-gpg-agent" if build.without? "gpg-agent"
    args << "--disable-nls" if build.without? "gettext"

    # The system Python is built with llvm-gcc, so we override this
    # variable to prevent failures due to incompatible CFLAGS
    ENV["ac_cv_python_compile"] = ENV.cc

    inreplace "Makefile.in",
              "toolsdir = @bindir@/svn-tools",
              "toolsdir = @libexecdir@/svn-tools"

    system "./configure", *args
    system "make"
    system "make", "install"
    bash_completion.install "tools/client-side/bash_completion" => "subversion"

    system "make", "tools"
    system "make", "install-tools"

    system "make", "swig-py"
    system "make", "install-swig-py"
    (lib/"python2.7/site-packages").install_symlink Dir["#{lib}/svn-python/*"]
  end

  test do
    system "#{bin}/svnadmin", "create", "test"
    system "#{bin}/svnadmin", "verify", "test"
  end
end
