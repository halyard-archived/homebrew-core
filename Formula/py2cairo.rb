class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.0/pycairo-1.16.0.tar.gz"
  sha256 "ac74772da9dff50b72f217d5383e4fd2d47782f91d1d513fb755841e95ba5604"

  depends_on "pkg-config" => :build
  depends_on "cairo"


  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
