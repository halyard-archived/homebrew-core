class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.1/pycairo-1.16.1.tar.gz"
  sha256 "47a14a6a2f8dadb649229f099ac712a5f3d0a22e14877165a203d8a0de09ad63"

  depends_on "pkg-config" => :build
  depends_on "cairo"


  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
