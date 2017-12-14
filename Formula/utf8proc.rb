class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://julialang.org/utf8proc/"
  url "https://github.com/JuliaLang/utf8proc/archive/v2.1.0.tar.gz"
  sha256 "241c409d8f6c0e4f332e41f3f1bd39552e36dcc00084fbacd03682b2969a301e"


  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
