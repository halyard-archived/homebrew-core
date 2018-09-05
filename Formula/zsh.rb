class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://www.zsh.org/pub/zsh-5.6.tar.xz"
  sha256 "746b1fcb11e8d129d1454f9ca551448c8145b6bcb157116c12407c518880e6d6"

  depends_on "gdbm"
  depends_on "pcre"

  resource "htmldoc" do
    url "https://www.zsh.org/pub/zsh-5.6-doc.tar.xz"
    sha256 "96e641b3311f67904f067b2bd353d875c609843677522b0e2a7cc7efd6edcbd9"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-fndir=#{pkgshare}/functions
      --enable-scriptdir=#{pkgshare}/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-runhelpdir=#{pkgshare}/help
      --enable-cap
      --enable-maildir-support
      --enable-multibyte
      --enable-pcre
      --enable-zsh-secure-free
      --with-tcsetpgrp
      --enable-unicode9
      --enable-etcdir=/etc
    ]

    system "./configure", *args

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make", "install"
    system "make", "install.info"

    resource("htmldoc").stage do
      (pkgshare/"htmldoc").install Dir["Doc/*.html"]
    end
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/zsh -c 'echo homebrew'").chomp
    system bin/"zsh", "-c", "printf -v hello -- '%s'"
  end
end
