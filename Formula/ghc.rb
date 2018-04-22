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

    # As of Xcode 7.3 (and the corresponding CLT) `nm` is a symlink to `llvm-nm`
    # and the old `nm` is renamed `nm-classic`. Building with the new `nm`, a
    # segfault occurs with the following error:
    #   make[1]: * [compiler/stage2/dll-split.stamp] Segmentation fault: 11
    # Upstream is aware of the issue and is recommending the use of nm-classic
    # until Apple restores POSIX compliance:
    # https://ghc.haskell.org/trac/ghc/ticket/11744
    # https://ghc.haskell.org/trac/ghc/ticket/11823
    # https://mail.haskell.org/pipermail/ghc-devs/2016-April/011862.html
    # LLVM itself has already fixed the bug: llvm-mirror/llvm@ae7cf585
    # rdar://25311883 and rdar://25299678
    if DevelopmentTools.clang_build_version >= 703 && DevelopmentTools.clang_build_version < 800
      args << "--with-nm=#{`xcrun --find nm-classic`.chomp}"
    end

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    if build.head?
      resource("cabal").stage do
        system "sh", "bootstrap.sh", "--sandbox"
        (buildpath/"bootstrap-tools/bin").install ".cabal-sandbox/bin/cabal"
      end

      ENV.prepend_path "PATH", buildpath/"bootstrap-tools/bin"

      cabal_sandbox do
        cabal_install "--only-dependencies", "happy", "alex"
        cabal_install "--prefix=#{buildpath}/bootstrap-tools", "happy", "alex"
      end

      system "./boot"
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
