require "language/haskell"

class PandocHalyard < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  _version = '2.0.5'
  url "https://hackage.haskell.org/package/pandoc-#{_version}/pandoc-#{_version}.tar.gz"
  sha256 "91245ae9f4a329883285bb13b9445b7c3d6a13d1d54baef34d9cfd47f777e018"
  head "https://github.com/jgm/pandoc.git"

  depends_on "cabal-install-halyard" => :build
  depends_on "ghc-halyard" => :build


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
