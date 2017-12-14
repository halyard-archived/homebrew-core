class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.4.8/libatomic_ops-7.4.8.tar.gz"
  sha256 "c405d5524b118c197499bc311b8ebe18f7fe47fc820f2c2fcefde1753fbd436a"


  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
