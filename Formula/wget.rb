class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.20.1.tar.gz"
  sha256 "b783b390cb571c837b392857945f5a1f00ec6b043177cc42abb8ee1b542ee1b3"

  depends_on "pkg-config" => :build
  depends_on "libidn2"
  depends_on "openssl"

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl"].opt_prefix}",
                          "--disable-debug",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--without-libpsl"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
