class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20181222.tar.xz"
  sha256 "53dc611524c40cddd242c972a9559f9793e128a0ce772483f12a2704c9f48c54"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
