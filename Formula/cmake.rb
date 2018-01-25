class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  head "https://cmake.org/cmake.git"

  url "https://cmake.org/files/v3.10/cmake-3.10.1.tar.gz"
  sha256 "7be36ee24b0f5928251b644d29f5ff268330a916944ef4a75e23ba01e7573284"

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
      url "https://gist.githubusercontent.com/akerl/58a4253fa6581ebbc815fa4e5fd08032/raw/4933bc75b991a27f1d1f1feb30f587e1e5ef89a4/gistfile1.txt"
      sha256 "5a664c8bd780e664c647f24355a2c0a24d24e52b1ce24df66db82456a083588a"
    end
  end


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
