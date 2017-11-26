class GtkxHalyard < Formula
  desc "GUI toolkit"
  homepage "https://gtk.org/"
  revision 1

  stable do
    url "https://download.gnome.org/sources/gtk+/3.22/gtk+-3.22.26.tar.xz"
    sha256 "61eef0d320e541976e2dfe445729f12b5ade53050ee9de6184235cb60cd4b967"
  end

  option "with-quartz-relocation", "Build with quartz relocation support"

  depends_on "pkg-config-halyard" => :build
  depends_on "gdk-pixbuf-halyard"
  depends_on "jasper-halyard" => :optional
  depends_on "atk-halyard"
  depends_on "pango-halyard"
  depends_on "gobject-introspection-halyard"
  depends_on "hicolor-icon-theme-halyard"

  conflicts_with "gtk+", :because => "gtk+-halyard replaces gtk+"

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--disable-glibtest",
            "--enable-introspection=yes",
            "--with-gdktarget=quartz",
            "--disable-visibility"]

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        GtkWidget *label = gtk_label_new("Hello World!");
        return 0;
      }
    EOS
    atk = Formula["atk-halyard"]
    cairo = Formula["cairo-halyard"]
    fontconfig = Formula["fontconfig-halyard"]
    freetype = Formula["freetype-halyard"]
    gdk_pixbuf = Formula["gdk-pixbuf-halyard"]
    gettext = Formula["gettext-halyard"]
    glib = Formula["glib-halyard"]
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
      -I#{include}/gtk-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gtk-2.0/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
