class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/mauke/unibilium"
  url "https://github.com/mauke/unibilium/archive/v2.0.0.tar.gz"
  sha256 "78997d38d4c8177c60d3d0c1aa8c53fd0806eb21825b7b335b1768d7116bc1c1"

  depends_on "libtool" => :build


  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <unibilium.h>
      #include <stdio.h>

      int main()
      {
        setvbuf(stdout, NULL, _IOLBF, 0);
        unibi_term *ut = unibi_dummy();
        unibi_destroy(ut);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunibilium", "-o", "test"
    system "./test"
  end
end
