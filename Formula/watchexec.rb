class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/releases/download/1.10.1/watchexec-1.10.1-x86_64-apple-darwin.tar.gz"
  sha256 "9f3e572200d516024697144d64612c89e3fce610b579251dc783dbeae07ac671"

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
