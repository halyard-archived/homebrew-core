class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190123.tar.xz"
  sha256 "edd13c7631af169e3838621b1a1bff3ef73cf7bc778eec2bd55f7c1089ffdf9b"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
