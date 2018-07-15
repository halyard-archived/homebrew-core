class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.8/annie_0.7.8_macOS_64-bit.tar.gz"
  version "0.7.8"
  sha256 "cd9f99cfebca1e33ba2ec66af2fdcf5b555b0a2e3b41acd6ad1b2847745f5eee"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
