class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://www.zsh.org/pub/zsh-5.6.1.tar.xz"
  sha256 "9566753f317d31b808b6b63a5622c71f25d473a6b5fea5c35ab1c7ed96fbb3e8"

  depends_on "gdbm"
  depends_on "pcre"

  resource "htmldoc" do
    url "https://www.zsh.org/pub/zsh-5.6.1-doc.tar.xz"
    sha256 "b64a290c0176d8844d0bd7349b59078536f798cfc7f4eab175595dd75ae04896"
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
