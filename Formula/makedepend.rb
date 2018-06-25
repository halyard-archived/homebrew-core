class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.5.tar.bz2"
  sha256 "f7a80575f3724ac3d9b19eaeab802892ece7e4b0061dd6425b4b789353e25425"
  revision 2

  depends_on "pkg-config" => :build

  resource "xorgproto" do
    url "https://xorg.freedesktop.org/releases/individual/proto/xorgproto-2018.4.tar.gz"
    sha256 "8e48d851efea0e951bcb6cf0d537f84ba3803de95e488bd039fe59fc75ec8f7d"
  end

  resource "xorg-macros" do
    url "https://xorg.freedesktop.org/releases/individual/util/util-macros-1.19.2.tar.bz2"
    sha256 "d7e43376ad220411499a79735020f9d145fdc159284867e99467e0d771f3e712"
  end

  def install
    resource("xorgproto").stage do
      ENV["MKDIRPROG"] = "mkdir -p"
      system "./configure", "--prefix=#{buildpath}/xorgproto"
      system "make", "install"
    end

    resource("xorg-macros").stage do
      system "./configure", "--prefix=#{buildpath}/xorg-macros"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xorgproto/share/pkgconfig"
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
