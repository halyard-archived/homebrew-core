class WebpHalyard < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.6.1.tar.gz"
  sha256 "06503c782d9f151baa325591c3579c68ed700ffc62d4f5a32feead0ff017d8ab"
  revision 1

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf-halyard" => :build
    depends_on "automake-halyard" => :build
    depends_on "libtool-halyard" => :build
  end

  depends_on "libpng-halyard"
  depends_on "jpeg-halyard" => :recommended
  depends_on "libtiff-halyard" => :optional
  depends_on "giflib-halyard" => :optional


  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-gl",
      "--enable-libwebpmux",
      "--enable-libwebpdemux",
      "--enable-libwebpdecoder",
      "--prefix=#{prefix}",
    ]
    args << "--disable-gif" if build.without? "giflib"
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
