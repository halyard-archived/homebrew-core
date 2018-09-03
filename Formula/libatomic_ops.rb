class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.6/libatomic_ops-7.6.6.tar.gz"
  sha256 "99feabc5f54877f314db4fadeb109f0b3e1d1a54afb6b4b3dfba1e707e38e074"


  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
