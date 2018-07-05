class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/releases/download/v0.6.0/gron-darwin-amd64-0.6.0.tgz"
  sha256 "40785d40e1d8b9a634ef7fcbcd471b579ff4dfe870dade595979722aaa1e06a9"

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
