class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.12/annie_0.7.12_macOS_64-bit.tar.gz"
  version "0.7.12"
  sha256 "7f48622a4dba39e17b18ce121902b0ff9a683feba6edd3df0c7bf7b101aea081"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
