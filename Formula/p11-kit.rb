class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/archive/0.23.11.tar.gz"
  #url "https://github.com/p11-glue/p11-kit/releases/download/0.23.11/p11-kit-0.23.11.tar.gz"
  sha256 "849d2a344acd4172645a5bb23097f96f42487139f8d42cb0af5398de287e46e8"
  revision 1

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libffi"
  depends_on "pkg-config" => :build
  # Remove these once 0.23.12 drops
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build

  patch do
    url "https://github.com/p11-glue/p11-kit/commit/db92b71654789b9b20a2083bf45370d560df2da2.patch"
    sha256 "9ec6b7d1069e45ea15e457f2d38396b3a04cb3dc9d11ce51d5d358710a83b5cb"
  end

  def install
    # Fix "error: unknown type name 'locale_t'"
    # Reported 25 May 2018 https://github.com/p11-glue/p11-kit/issues/158
    inreplace %w[common/debug.c common/library.c common/message.c
                 common/test-message.c],
              "#include <locale.h>", "#include <xlocale.h>"

    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    #if build.head?
    ENV["NOCONFIGURE"] = "1"
    system "./autogen.sh"
    #end

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
