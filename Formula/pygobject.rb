class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.28/pygobject-3.28.1.tar.xz"
  sha256 "42312b4a5015571fa0a4f2d201005da46b71c251ea2625bc95702d071c4ff895"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python"


  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
    (lib/"python2.7/site-packages/pygtk.pth").append_lines <<~EOS
      #{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0
    EOS
  end

  test do
    system "python", "-c", "import dsextras"
  end
end
