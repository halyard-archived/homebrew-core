class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.17.tar.gz"
  sha256 "7cd8cc2e35b1aaede6084ea57cc9447752f498daaea854100a4bad567614977d"

  option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."


  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --without-readline
      --prefix=#{prefix}
    ]

    args << "--enable-libgdbm-compat" if build.with? "libgdbm-compat"

    system "./configure", *args
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
