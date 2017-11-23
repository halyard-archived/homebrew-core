class NpthHalyard < Formula
  desc "New GNU portable threads library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/npth/npth-1.5.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/npth/npth-1.5.tar.bz2"
  sha256 "294a690c1f537b92ed829d867bee537e46be93fbd60b16c04630fbbfcd9db3c2"

  conflicts_with "npth", :because => "npth-halyard replaces npth"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/npth-config", "--version"
  end
end
