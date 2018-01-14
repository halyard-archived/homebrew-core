class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/releases/download/v0.5.1/gron-darwin-amd64-0.5.1.tgz"
  sha256 "d314ef3d1dca815cc21ff4fdd9b7e4d1e95dedc429628aecdc87d3270046fb0e"

  def install
    bin.install "gron"
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/gron", "{\"foo\":1, \"bar\":2}")
      json = {};
      json.bar = 2;
      json.foo = 1;
    EOS
  end
end
