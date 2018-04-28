require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  _version = '2.2'
  url "https://hackage.haskell.org/package/pandoc-#{_version}/pandoc-#{_version}.tar.gz"
  sha256 "0f2984a6ea4948392154ecdcffcc21c561976c63f9c8aa648a56a677b80e8569"
  head "https://github.com/jgm/pandoc.git"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build


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
