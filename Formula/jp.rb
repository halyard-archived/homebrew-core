class Jp < Formula
  desc "Plot JSON data in the terminal"
  homepage "https://github.com/sgreben/jp"
  url "https://github.com/sgreben/jp/releases/download/1.1.11/jp_1.1.11_osx_x86_64.zip"
  version "1.1.11"
  sha256 "0af7c90ca3c1e70a5f71e7c0ed0e327a10f8bcecaa71b304f340b7d3fbe2d87e"

  def install
    bin.install "jp"
  end
end
