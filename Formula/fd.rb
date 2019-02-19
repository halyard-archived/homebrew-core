class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/releases/download/v7.3.0/fd-v7.3.0-x86_64-apple-darwin.tar.gz"
  version "7.3.0"
  sha256 "c37cd27c3e3f31dc0c676854cb9dd20470a2815a3a37d012d52e93c0ea9432a8"

  def install
    bin.install 'fd'
    man1.install "fd.1"
    bash_completion.install "autocomplete/fd.bash-completion"
    zsh_completion.install "autocomplete/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
