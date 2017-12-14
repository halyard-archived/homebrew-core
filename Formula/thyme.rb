class Thyme < Formula
  desc "Automatically track which applications you use and for how long"
  homepage "https://github.com/sourcegraph/thyme"

  version "0.2.3"
  url "https://github.com/sourcegraph/thyme/releases/download/#{version}/thyme-darwin-386"
  sha256 "5b4cc7c652fab72724ec4e0160174007ed1e6013679b19aa7d8017b77bc52ce1"

  def install
    mv "thyme-darwin-386", "thyme"
    bin.install "thyme"
  end

  test do
    system bin/"thyme", "list"
  end
end
