require "language/haskell"

class PandocHalyard < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0.3/pandoc-2.0.3.tar.gz"
  sha256 "d814e087da1f06774353d0da14b744966c480bb49af7d6167f0010edd92cb3ee"
  head "https://github.com/jgm/pandoc.git"

  depends_on "cabal-install-halyard" => :build
  depends_on "ghc-halyard" => :build

  conflicts_with "pandoc", :because => "pandoc-halyard replaces pandoc"

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
