class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.22.tar.gz"
  sha256 "6945bd3c4aaa83da83d80a045c5563da4edd7d0374c62c0d35aec09eb3014600"

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "unibilium"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
