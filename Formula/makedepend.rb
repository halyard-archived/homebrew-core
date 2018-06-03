class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.5.tar.bz2"
  sha256 "f7a80575f3724ac3d9b19eaeab802892ece7e4b0061dd6425b4b789353e25425"
  revision 2

  depends_on "pkg-config" => :build

  resource "xproto" do
    url "https://xorg.freedesktop.org/releases/individual/proto/xproto-7.0.31.tar.gz"
    sha256 "6d755eaae27b45c5cc75529a12855fed5de5969b367ed05003944cf901ed43c7"
  end

  resource "xorg-macros" do
    url "https://xorg.freedesktop.org/releases/individual/util/util-macros-1.19.2.tar.bz2"
    sha256 "d7e43376ad220411499a79735020f9d145fdc159284867e99467e0d771f3e712"
  end

  def install
    resource("xproto").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{buildpath}/xproto"
      system "make", "install"
    end

    resource("xorg-macros").stage do
      system "./configure", "--prefix=#{buildpath}/xorg-macros"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xproto/lib/pkgconfig"
    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xorg-macros/share/pkgconfig"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "Makefile"
    system "#{bin}/makedepend"
  end
end
