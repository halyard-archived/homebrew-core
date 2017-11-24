class LibuvHalyard < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.17.0.tar.gz"
  sha256 "c7282fd7ccec9b8c331e7bb6d5008617f8a980e61ec5748be61c263b85efb47c"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  option "with-test", "Execute compile time checks (Requires Internet connection)"

  depends_on "pkg-config-halyard" => :build
  depends_on "automake-halyard" => :build
  depends_on "autoconf-halyard" => :build
  depends_on "libtool-halyard" => :build
  depends_on "sphinx-doc-halyard" => :build

  conflicts_with "libuv", :because => "libuv-halyard replaces libuv"

  def install
    # This isn't yet handled by the make install process sadly.
    cd "docs" do
      system "make", "man"
      system "make", "singlehtml"
      man1.install "build/man/libuv.1"
      doc.install Dir["build/singlehtml/*"]
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uv.h>
      #include <stdlib.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
