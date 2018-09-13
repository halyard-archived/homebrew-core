class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/releases/download/1.9.2/watchexec-1.9.2-x86_64-apple-darwin.tar.gz"
  sha256 "0e4765a01c994360917766e0d2bc9b6a8f6e5e190a37806d2c2552bc85ac7c04"

  def install
    bin.install "watchexec"
    man1.install "watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
