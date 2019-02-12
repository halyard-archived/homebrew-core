class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz"
  sha256 "3a44a802631606e138a9e172a3e9f5bcbaac43ce2895c1d8e2b46f30487e77a3"

  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    # Fix "error: use of undeclared identifier 'make_unique'"
    # Reported upstream 15 May 2018 https://github.com/aria2/aria2/issues/1198
    inreplace "src/bignum.h", "make_unique", "std::make_unique"
    inreplace "configure", "-std=c++11", "-std=c++14"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-appletls
      --with-libssh2
      --without-openssl
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "https://brew.sh/"
    assert_predicate testpath/"index.html", :exist?, "Failed to create index.html!"
  end
end
