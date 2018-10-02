class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20181001.tar.xz"
  sha256 "46242e6ddc5f8e2cffbb5cf9634399e1d0f7b9d9634d09c35b65ac8f4bbe222a"
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
