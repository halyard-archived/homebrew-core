class LibuvHalyard < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.18.0.tar.gz"
  sha256 "772f93776ba68a357b515cda1515ce898674ef6cde30826d0cac64ce9950ebb0"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  option "with-test", "Execute compile time checks (Requires Internet connection)"

  depends_on "pkg-config-halyard" => :build
  depends_on "automake-halyard" => :build
  depends_on "autoconf-halyard" => :build
  depends_on "libtool-halyard" => :build
  depends_on "sphinx-doc-halyard" => :build


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
