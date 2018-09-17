class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.8.1/annie_0.8.1_macOS_64-bit.tar.gz"
  version "0.8.1"
  sha256 "98725f8e040e20fe3d1270115166f0eacc9ab1963722a3752d9262cd2e5f93e8"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
