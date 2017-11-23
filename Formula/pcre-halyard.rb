class PcreHalyard < Formula
  desc "Perl compatible regular expressions library"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.41.tar.bz2"
  sha256 "e62c7eac5ae7c0e7286db61ff82912e1c0b7a0c13706616e94a7dd729321b530"

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "automake-halyard" => :build
    depends_on "autoconf-halyard" => :build
    depends_on "libtool-halyard" => :build
  end

  conflicts_with 'pcre', :because => 'halyard/homebrew-core/pcre replaces pcre'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8",
                          "--enable-pcre8",
                          "--enable-pcre16",
                          "--enable-pcre32",
                          "--enable-unicode-properties",
                          "--enable-pcregrep-libz",
                          "--enable-pcregrep-libbz2",
                          "--enable-jit"
    system "make"
    ENV.deparallelize
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pcregrep", "regular expression", "#{prefix}/README"
  end
end
