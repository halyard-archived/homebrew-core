class LibrsvgHalyard < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://live.gnome.org/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.40/librsvg-2.40.19.tar.xz"
  sha256 "612b4d8b8609036f5d899be3fe70d9866b5f6ac5c971154c1c0ef7242216c1f7"

  depends_on "pkg-config-halyard" => :build
  depends_on "cairo-halyard"
  depends_on "gdk-pixbuf-halyard"
  depends_on "glib-halyard"
  depends_on "libcroco-halyard"
  depends_on "pango-halyard"
  depends_on "gtk+-halyard" => :optional

  conflicts_with "librsvg", :because => "librsvg-halyard replaces librsvg"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-Bsymbolic
      --enable-tools=yes
      --enable-pixbuf-loader=yes
      --enable-introspection=yes
    ]

    system "./configure", *args

    # disable updating gdk-pixbuf cache, we will do this manually in post_install
    # https://github.com/Homebrew/homebrew/issues/40833
    inreplace "gdk-pixbuf-loader/Makefile",
              "$(GDK_PIXBUF_QUERYLOADERS) > $(DESTDIR)$(gdk_pixbuf_cache_file) ;",
              ""

    system "make", "install",
      "gdk_pixbuf_binarydir=#{lib}/gdk-pixbuf-2.0/2.10.0/loaders",
      "gdk_pixbuf_moduledir=#{lib}/gdk-pixbuf-2.0/2.10.0/loaders"
  end

  def post_install
    # librsvg is not aware GDK_PIXBUF_MODULEDIR must be set
    # set GDK_PIXBUF_MODULEDIR and update loader cache
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    system "#{Formula["gdk-pixbuf-halyard"].opt_bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librsvg/rsvg.h>

      int main(int argc, char *argv[]) {
        RsvgHandle *handle = rsvg_handle_new();
        return 0;
      }
    EOS
    cairo = Formula["cairo-halyard"]
    fontconfig = Formula["fontconfig-halyard"]
    freetype = Formula["freetype-halyard"]
    gdk_pixbuf = Formula["gdk-pixbuf-halyard"]
    gettext = Formula["gettext-halyard"]
    glib = Formula["glib-halyard"]
    libpng = Formula["libpng-halyard"]
    pixman = Formula["pixman-halyard"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/librsvg-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lm
      -lrsvg-2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end