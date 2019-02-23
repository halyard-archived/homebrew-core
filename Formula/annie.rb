class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.9.2/annie_0.9.2_macOS_64-bit.tar.gz"
  version "0.9.2"
  sha256 "da380f4e4735dc6ed00ff67227b17cf3f8d4b21a49149fa2b4d94c6dd656d398"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
