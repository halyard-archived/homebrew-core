class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/releases/download/1.9.0/watchexec-1.9.0-x86_64-apple-darwin.tar.gz"
  sha256 "01eebc8fe1ee8714dd1b18f8e88d617691aceff3adc99232d046557294728306"

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
