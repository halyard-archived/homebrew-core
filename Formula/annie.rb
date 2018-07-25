class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.11/annie_0.7.11_macOS_64-bit.tar.gz"
  version "0.7.11"
  sha256 "64706e37869f0bbab999aa5376205ff2c4960949ea0f40153b404cdaa5aeffc0"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
