class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.1.7.tar.gz"
  sha256 "94096e4f43fd06071bbb4a6827a9ab4eeff52036adb662f329ffc7c1d198436d"


  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match /Screen Size - Width = 1, Height = 1/, shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
  end
end
