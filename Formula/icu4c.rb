class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  revision 1
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  stable do
    url "https://ssl.icu-project.org/files/icu4c/61.1/icu4c-61_1-src.tgz"
    version "61.1"
    sha256 "d007f89ae8a2543a53525c74359b65b36412fa84b3349f1400be6dcf409fafef"
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"


  def install
    args = %W[--prefix=#{prefix} --disable-samples --disable-tests --enable-static]
    args << "--with-library-bits=64" if MacOS.prefer_64_bit?

    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end
