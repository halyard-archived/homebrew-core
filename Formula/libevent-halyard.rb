class LibeventHalyard < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"
  url "https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz"
  sha256 "316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d"

  depends_on "autoconf-halyard" => :build
  depends_on "automake-halyard" => :build
  depends_on "doxygen-halyard" => :build
  depends_on "libtool-halyard" => :build
  depends_on "pkg-config-halyard" => :build
  depends_on "openssl-halyard"

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"
  conflicts_with "libevent", :because => "libevent-halyard replaces libevent"

  def install
    inreplace "Doxyfile", /GENERATE_MAN\s*=\s*NO/, "GENERATE_MAN = YES"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "doxygen"
    man3.install Dir["doxygen/man/man3/*.3"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-levent", "-o", "test"
    system "./test"
  end
end
