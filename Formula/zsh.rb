class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://www.zsh.org/pub/zsh-5.5.1.tar.gz"
  sha256 "774caa89e7aea5f33c3033cbffd93e28707f72ba5149c79709e48e6c2d2ee080"

  depends_on "gdbm"
  depends_on "pcre"

  resource "htmldoc" do
    url "https://www.zsh.org/pub/zsh-5.5.1-doc.tar.xz"
    sha256 "41ce13a89a6bc7e709b6f110e54288d59f02ba2becd2646895d28188d4dd6283"
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
