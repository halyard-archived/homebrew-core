class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180613.tar.xz"
  sha256 "3e22e6f2a715f05f9bbc5b1a9c737ab2edc8f26b2af61f9cc31f83391cd663ff"
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
