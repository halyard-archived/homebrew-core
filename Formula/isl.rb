class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr"
  url "http://isl.gforge.inria.fr/isl-0.20.tar.xz"
  sha256 "a5596a9fb8a5b365cb612e4b9628735d6e67e9178fae134a816ae195017e77aa"

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "check"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end
