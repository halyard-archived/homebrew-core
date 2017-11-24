class GuileHalyard < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-2.2.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-2.2.2.tar.xz"
  sha256 "1c91a46197fb1adeba4fd62a25efcf3621c6450be166d7a7062ef6ca7e11f5ab"

  head do
    url "https://git.savannah.gnu.org/git/guile.git"

    depends_on "autoconf-halyard" => :build
    depends_on "automake-halyard" => :build
    depends_on "gettext-halyard" => :build
  end

  depends_on "pkg-config-halyard" => :run # guile-config is a wrapper around pkg-config.
  depends_on "libtool-halyard" => :run
  depends_on "libffi-halyard"
  depends_on "libunistring-halyard"
  depends_on "bdw-gc-halyard"
  depends_on "gmp-halyard"
  depends_on "readline-halyard"

  conflicts_with "guile", :because => "guile-halyard replaces guile"

  fails_with :clang do
    build 211
    cause "Segfaults during compilation"
  end

  def install
    system "./autogen.sh" unless build.stable?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline-halyard"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp-halyard"].opt_prefix}"
    system "make", "install"

    # A really messed up workaround required on macOS --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  test do
    hello = testpath/"hello.scm"
    hello.write <<~EOS
      (display "Hello World")
      (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
