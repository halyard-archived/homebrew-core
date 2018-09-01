class Trash < Formula
  desc "A command-line tool for macOS, written in Swift, that moves files to the current user's trash folder."
  homepage "https://github.com/macmade/trash"

  url "https://github.com/macmade/trash/archive/f28e3f4aec2f04652300dc53da7fac48feb97f4e.zip"
  version "0.0.1"
  sha256 "590ed5f7ed971477f72b027b382da026707befc91cc966ce1009220022814f2b"

  depends_on :xcode => 8.0

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/trash"
  end

  test do
    system "touch", "foo.txt"
    system "#{bin}/trash", "foo.txt"
  end
end
