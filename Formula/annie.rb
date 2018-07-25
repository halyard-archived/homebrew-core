class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.10/annie_0.7.10_macOS_64-bit.tar.gz"
  version "0.7.10"
  sha256 "96026a5c95e50f7c40cc76c273975191f1dfbe64e97395d4d7412b08cda2aadc"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
