class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.29/pygobject-3.29.2.tar.xz"
  sha256 "8d77b1ac1d7c88929ac9f5793837f7933e80cdd27523a47d38cdf2cf03c1f4a1"
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
