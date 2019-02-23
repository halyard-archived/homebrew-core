class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.21.1.tar.gz"
  sha256 "cecbf737f35d18f433c8d7864f63c0f878af41f8bd0255a3ebb16010dc044d5f"

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "unibilium"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
