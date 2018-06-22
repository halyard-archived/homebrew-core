class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/releases/download/0.7.4/annie_0.7.4_macOS_64-bit.tar.gz"
  version "0.7.4"
  sha256 "f0512596c9a83633a4142399685373a7d6df5a5e7f8526c695613e513f29ef6a"

  def install
    bin.install "annie"
  end

  test do
    system bin/"annie", "-i", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  end
end
