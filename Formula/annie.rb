class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.20/annie_0.7.20_macOS_64-bit.tar.gz"
  version "0.7.20"
  sha256 "4019e8a0374765a4c503367d05dfac1029d2a5e6db0ed6eb891f20099182bdda"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
