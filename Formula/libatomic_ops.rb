class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.10/libatomic_ops-7.6.10.tar.gz"
  sha256 "587edf60817f56daf1e1ab38a4b3c729b8e846ff67b4f62a6157183708f099af"


  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
