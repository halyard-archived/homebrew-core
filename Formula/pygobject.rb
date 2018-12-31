class Pygobject < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.4.tar.xz"
  sha256 "2dc1a1a444b82955e65b81c2a2511ecf8032404beba4ef1d48144168f2f64c43"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "libffi"
  depends_on "py2cairo"
  depends_on "py3cairo"
  depends_on "python"
  depends_on "python@2"

  def install
    Language::Python.each_python(build) do |python, _version|
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "PYTHON=#{python}"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, pyversion|
      ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
      system python, "test.py"
    end
  end
end
