class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.4/libatomic_ops-7.6.4.tar.gz"
  sha256 "5b823d5a685dd70caeef8fc50da7d763ba7f6167fe746abca7762e2835b3dd4e"


  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
