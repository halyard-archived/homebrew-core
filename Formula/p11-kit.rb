class P11KitHalyard < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.9/p11-kit-0.23.9.tar.gz"
  sha256 "e1c1649c335107a8d33cf3762eb7f57b2d0681f0c7d8353627293a58d6b4db63"

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf-halyard" => :build
    depends_on "automake-halyard" => :build
    depends_on "gettext-halyard" => :build
    depends_on "libtool-halyard" => :build
  end

  depends_on "libffi-halyard"
  depends_on "pkg-config-halyard" => :build

  conflicts_with "p11-kit", :because => "p11-kit-halyard replaces p11-kit"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-trust-module",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--without-libtasn1"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
