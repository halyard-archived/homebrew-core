class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.2/annie_0.7.2_macOS_64-bit.tar.gz"
  version "0.7.2"
  sha256 "460c26edfb7d9b22cbbe34f9d48f352d4b95d14a4488a4995328eae3f1a24118"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
