# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp4
# - opam
#
# Applications that really shouldn't break on a compiler update are:
# - mldonkey
# - coq
# - coccinelle
# - unison
class OcamlHalyard < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.06/ocaml-4.06.0.tar.xz"
  sha256 "1236b5f91e1c075086d69e2d40cfab21e048b9fe38e902f707815bebbc20c5b7"
  head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

  option "with-x11", "Install with the Graphics module"
  option "with-flambda", "Install with flambda support"

  depends_on :x11 => :optional

  conflicts_with "ocaml", :because => "ocaml-halyard replaces ocaml"

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = ["-prefix", HOMEBREW_PREFIX.to_s, "-with-debug-runtime", "-mandir", man]
    args << "-no-graph" if build.without? "x11"
    args << "-flambda" if build.with? "flambda"
    system "./configure", *args

    system "make", "world.opt"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
