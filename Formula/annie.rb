class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  version "0.6.12"
  url "https://github.com/iawia002/annie/releases/download/#{version}/annie_#{version}_macOS_64-bit.tar.gz"
  sha256 "ae24f9209a79ead30cc2de667fd8e312b1cd214182c99c6466e26bb8b2811b42"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
