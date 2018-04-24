require "language/haskell"

class Ghc < Formula
  include Language::Haskell::Cabal

  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.4.2/ghc-8.4.2-src.tar.xz"
  sha256 "01cc32f24a06bf3b2428351b6d7fec791e82d042426d29ad9e5a245b35f0047b"

  option "with-test", "Verify the build using the testsuite"
  option "without-docs", "Do not build documentation (including man page)"

  depends_on "python" => :build if build.with?("test")
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "gmp"

  # https://www.haskell.org/ghc/download_ghc_8_0_1#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  resource "binary" do
    url "https://downloads.haskell.org/~ghc/8.4.2/ghc-8.4.2-x86_64-apple-darwin.tar.xz"
    sha256 "87469222042b9ac23f9db216a8d4e5107297bdbbb99df71eb4d9e7208455def2"
  end

  resource "testsuite" do
    url "https://downloads.haskell.org/~ghc/8.4.2/ghc-8.4.2-testsuite.tar.xz"
    sha256 "31315100daf5997df90c94d66747f597490ac37fca192fad9e6279af1ae05a35"
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    args = []

    # Setting -march=native, which is what --build-from-source does, fails
    # on Skylake (and possibly other architectures as well) with the error
    # "Segmentation fault: 11" for at least the following files:
    #   utils/haddock/dist/build/Haddock/Backends/Hyperlinker/Types.dyn_o
    #   utils/haddock/dist/build/Documentation/Haddock/Types.dyn_o
    #   utils/haddock/dist/build/Haddock/GhcUtils.dyn_o
    #   utils/haddock/dist/build/Paths_haddock.dyn_o
    #   utils/haddock/dist/build/ResponseFile.dyn_o
    # Setting -march=core2 works around the bug.
    # Reported 22 May 2016: https://ghc.haskell.org/trac/ghc/ticket/12100
    ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}"

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    if build.with?("test")
      resource("testsuite").stage { buildpath.install Dir["*"] }
      cd "testsuite" do
        system "make", "clean"
        system "make", "CLEANUP=1", "THREADS=#{ENV.make_jobs}", "fast"
      end
    end

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    system "#{bin}/runghc", testpath/"hello.hs"
  end
end
