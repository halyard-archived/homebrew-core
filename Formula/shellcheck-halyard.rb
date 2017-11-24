require "language/haskell"

class ShellcheckHalyard < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.6.tar.gz"
  sha256 "1c3cd8995ebebf6c8e5475910809762b91bebf0a3827ad87a0c392c168326de2"
  head "https://github.com/koalaman/shellcheck.git"

  depends_on "ghc-halyard" => :build
  depends_on "cabal-install-halyard" => :build
  depends_on "pandoc-halyard" => :build

  conflicts_with "shellcheck", :because => "shellcheck-halyard replaces shellcheck"

  def install
    install_cabal_package
    system "pandoc", "-s", "-t", "man", "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~EOS
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
