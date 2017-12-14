class LibtermkeyHalyard < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.20.tar.gz"
  sha256 "6c0d87c94ab9915e76ecd313baec08dedf3bd56de83743d9aa923a081935d2f5"

  depends_on "pkg-config-halyard" => :build
  depends_on "libtool-halyard" => :build


  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
