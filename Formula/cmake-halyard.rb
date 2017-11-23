class CmakeHalyard < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  head "https://cmake.org/cmake.git"

  url "https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz"
  sha256 "b3345c17609ea0f039960ef470aa099de9942135990930a57c14575aae884987"

  # The two patches below fix cmake for undefined symbols check on macOS 10.12
  # They can be removed for cmake >= 3.10
  if MacOS.version == :sierra && DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://gitlab.kitware.com/cmake/cmake/commit/96329d5dffdd5a22c5b4428119b5d3762a8857a7.diff"
      sha256 "c394d1b6e59e9bcf8e5db8a0a1189203e056c230a22aa8d60079fea7be6026bd"
    end

    patch do
      url "https://gitlab.kitware.com/cmake/cmake/commit/f1a4ecdc0c62b46c90df5e8d20e6f61d06063894.diff"
      sha256 "d32fa9c342d88e53b009f1fbeecc5872a79eec4bf2c8399f0fc2eeda5b0a4f1e"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/105060cf885/cmake/cmake-backport-kwsys-utimensat-fix.diff"
      sha256 "3e8aa1a6a1039e7a9be6fd0ca6abf09ca00fb07e1275bb3e55dc44b8b9dc746c"
    end
  end

  conflicts_with 'cmake', :because => 'halyard/homebrew-core/cmake replaces cmake'

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    system "./bootstrap", *args
    system "make"
    system "make", "install"

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
