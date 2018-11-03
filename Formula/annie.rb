class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.8.3/annie_0.8.3_macOS_64-bit.tar.gz"
  version "0.8.3"
  sha256 "91cd007d483fdcf7b0d17b236dc54316b1b226c7b1b7761f9abb3e2a95d8aadc"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
