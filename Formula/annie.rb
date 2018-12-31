class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.9.0/annie_0.9.0_macOS_64-bit.tar.gz"
  version "0.9.0"
  sha256 "8e9263a5351d956a98bff25dc3837729cdd35cf27fa43a06c88e0454410857ac"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
