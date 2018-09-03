class Pygobject < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.0.tar.xz"
  sha256 "7d20ba1475df922f4c26c69274ab89f7e7730d2101e46846caaddc53afd56bd0"

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "glib"
  depends_on "python@2"
  depends_on "python"
  depends_on "py2cairo"
  depends_on "py3cairo"
  depends_on "gobject-introspection"

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
