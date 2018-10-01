class Bzip2 < Formula
  desc "Freely available high-quality data compressor"
  homepage "https://en.wikipedia.org/wiki/Bzip2"
  url "https://fossies.org/linux/misc/bzip2-1.0.6.tar.gz"
  sha256 "a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd"
  revision 2

  keg_only :provided_by_macos

  def install
    inreplace "Makefile", "$(PREFIX)/man", "$(PREFIX)/share/man"

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz2"

    testfilepath.write "TEST CONTENT"

    system "#{bin}/bzip2", testfilepath
    system "#{bin}/bunzip2", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
