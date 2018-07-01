class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.5/annie_0.7.5_macOS_64-bit.tar.gz"
  version "0.7.5"
  sha256 "a12de17c650a0803d6a6b3dc63d8341b95ce2f05ffe51ed656b856d9bece87cf"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
