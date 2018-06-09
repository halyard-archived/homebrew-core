class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.3/annie_0.7.3_macOS_64-bit.tar.gz"
  version "0.7.3"
  sha256 "7b4e9756f49748e1ab3058f40bb6ea7cb3d6daebc804cb24dcacd57960ffc5ee"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
