class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/releases/download/v0.5.2/gron-darwin-amd64-0.5.2.tgz"
  sha256 "488d928fd743560df4f33bfb380ebb8ade430b93b6ba06fce43f875c35d2f5fb"

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
