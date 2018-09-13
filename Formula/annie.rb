class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.8.0/annie_0.8.0_macOS_64-bit.tar.gz"
  version "0.8.0"
  sha256 "d8989ad35e652f8d79f239e5a9879cb2776739126b7f6f6d9ad361b0f12844fc"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
