class LibgladeHalyard < Formula
  desc "RAD tool to help build GTK+ interfaces"
  homepage "https://glade.gnome.org"
  url "https://ftp.gnome.org/pub/GNOME/sources/glade/3.20/glade-3.20.1.tar.xz"
  sha256 "8064676dd46baa7e00c38ec1cc3ddc75c4ef5e714cd9d1491309b4df3e9cb1df"
  revision 1

  depends_on "pkg-config-halyard" => :build
  depends_on "libxml2-halyard"
  depends_on "gtk+-halyard"

  conflicts_with "libglade", :because => "libglade-halyard replaces libglade"

  def install
    ENV.append "LDFLAGS", "-lgmodule-2.0"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <glade/glade.h>

      int main(int argc, char *argv[]) {
        glade_init();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk-halyard"]
    cairo = Formula["cairo-halyard"]
    fontconfig = Formula["fontconfig-halyard"]
    freetype = Formula["freetype-halyard"]
    gdk_pixbuf = Formula["gdk-pixbuf-halyard"]
    gettext = Formula["gettext-halyard"]
    glib = Formula["glib-halyard"]
    gtkx = Formula["gtk+-halyard"]
    libpng = Formula["libpng-halyard"]
    pango = Formula["pango-halyard"]
    pixman = Formula["pixman-halyard"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/libglade-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglade-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
