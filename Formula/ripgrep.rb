class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/releases/download/0.8.0/ripgrep-0.8.0-x86_64-apple-darwin.tar.gz"
  sha256 "fb35e92fd57d28a1e68daf964764c3da7f027ad30cca7a07a1848224776f36b2"

  def install
    bin.install "rg"
    man1.install "doc/rg.1"

    bash_completion.install "complete/rg.bash"
    fish_completion.install "complete/rg.fish"
    zsh_completion.install "complete/_rg"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
