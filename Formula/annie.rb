class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.9.3/annie_0.9.3_macOS_64-bit.tar.gz"
  version "0.9.3"
  sha256 "546d5412e70de9a53129554344a7230129de929de2a694c25316508b089696b8"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
