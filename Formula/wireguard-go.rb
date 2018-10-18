class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20181018.tar.xz"
  sha256 "6bedec38d12596d55cfba4b3f7dfa99d5c2555c2f0bf3b3c9a26feb7c6b073ff"
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
