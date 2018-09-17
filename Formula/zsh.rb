class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://www.zsh.org/pub/zsh-5.6.2.tar.xz"
  sha256 "a50bd66c0557e8eca3b8fa24e85d0de533e775d7a22df042da90488623752e9e"

  depends_on "gdbm"
  depends_on "pcre"

  resource "htmldoc" do
    url "https://www.zsh.org/pub/zsh-5.6.2-doc.tar.xz"
    sha256 "98973267547cbdd8471b52e3a2bbe415be2c2c473246536ed8914f685e260114"
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
