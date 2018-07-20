class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.9/annie_0.7.9_macOS_64-bit.tar.gz"
  version "0.7.9"
  sha256 "78a17b604c534a061c80e5a02a2ef13ba21bd65ba4e5087926df78ed3f7bce76"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
