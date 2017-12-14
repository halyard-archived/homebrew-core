class Pcre2Halyard < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre2-10.30.tar.bz2"
  sha256 "90bd41c605d30e3745771eb81928d779f158081a51b2f314bbcc1f73de5773db"

  head "svn://vcs.exim.org/pcre2/code/trunk"

  conflicts_with 'pcre2', :because => 'pcre2-halyard replaces pcre2'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
