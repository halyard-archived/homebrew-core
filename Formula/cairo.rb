class CairoHalyard < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.14.10.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cairo-1.14.10.tar.xz"
  sha256 "7e87878658f2c9951a14fc64114d4958c0e65ac47530b8ac3078b2ce41b66a09"

  head do
    url "https://anongit.freedesktop.org/git/cairo", :using => :git
    depends_on "automake-halyard" => :build
    depends_on "autoconf-halyard" => :build
    depends_on "libtool-halyard" => :build
  end

  keg_only :provided_pre_mountain_lion

  depends_on "pkg-config-halyard" => :build
  depends_on :x11 => :optional
  depends_on "freetype-halyard"
  depends_on "fontconfig-halyard"
  depends_on "libpng-halyard"
  depends_on "pixman-halyard"
  depends_on "glib-halyard"


  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-gobject=yes
      --enable-svg=yes
      --enable-tee=yes
      --enable-quartz-image
    ]

    if build.with? "x11"
      args << "--enable-xcb=yes" << "--enable-xlib=yes" << "--enable-xlib-xrender=yes"
    else
      args << "--enable-xcb=no" << "--enable-xlib=no" << "--enable-xlib-xrender=no"
    end

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cairo.h>

      int main(int argc, char *argv[]) {

        cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 600, 400);
        cairo_t *context = cairo_create(surface);

        return 0;
      }
    EOS
    fontconfig = Formula["fontconfig-halyard"]
    freetype = Formula["freetype-halyard"]
    gettext = Formula["gettext-halyard"]
    glib = Formula["glib-halyard"]
    libpng = Formula["libpng-halyard"]
    pixman = Formula["pixman-halyard"]
    flags = %W[
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairo
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -L#{lib}
      -lcairo
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
