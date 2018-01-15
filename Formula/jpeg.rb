class Jpeg < Formula
  desc "Image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9c.tar.gz"
  sha256 "39e111cd9da5e72a589b98feeded334bb0e5776511e507e3d811ab25a213a3cd"


  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
