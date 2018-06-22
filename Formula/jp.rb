class Jp < Formula
  desc "Plot JSON data in the terminal"
  homepage "https://github.com/sgreben/jp"
  url "https://github.com/sgreben/jp/releases/download/1.1.12/jp_1.1.12_osx_x86_64.zip"
  version "1.1.12"
  sha256 "d1cccd9099ccd17203793ff48ec8bab0dfd6edb07c61afd070e9bf281d2453e2"

  def install
    bin.install "jp"
  end
end
