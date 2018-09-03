class Trash < Formula
  desc "A Mac CLI tool that moves files to the current user's trash folder."
  homepage "https://github.com/macmade/trash"

  url "https://github.com/macmade/trash/archive/f28e3f4.tar.gz"
  version "0.0.1-f28e3f4"
  sha256 "e45cbc89c2a912ae67fcd5bfc6b218b2351b75715c8c597f77b6fe6b00b88575"

  depends_on :xcode => 8.0

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/trash"
  end

  test do
    touch "foo.txt"
    system "#{bin}/trash", "foo.txt"
  end
end
