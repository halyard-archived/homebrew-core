class UnibiliumHalyard < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/mauke/unibilium"
  url "https://github.com/mauke/unibilium/archive/v1.2.1.tar.gz"
  sha256 "6045b4f6adca7b1123284007675ca71f718f70942d3a93d8b9fa5bd442006ec1"

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
