class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/releases/download/1.8.6/watchexec-1.8.6-x86_64-apple-darwin.tar.gz"
  sha256 "a5c53e7a248bd9e12d54915d12422d237a1c5563466afa6680ba86a0deb94c86"

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
