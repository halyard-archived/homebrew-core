class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.8.2/annie_0.8.2_macOS_64-bit.tar.gz"
  version "0.8.2"
  sha256 "5de6136d5af4400e8cf813df6ac58b002f5a0aa17a76487a59686a62c7485536"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
