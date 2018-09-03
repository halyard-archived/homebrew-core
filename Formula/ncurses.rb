class Ncurses < Formula
  desc "Text-based UI library"
  homepage "https://www.gnu.org/software/ncurses/"
  url "https://invisible-mirror.net/archives/ncurses/current/ncurses-6.1-20180901.tgz"
  sha256 "93933f64d26fe4b224264fb16ec5e13345d0f3fe51275a735ccc6b9f028292d8"

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build


  def install
    # Fix the build for GCC 5.1
    # error: expected ')' before 'int' in definition of macro 'mouse_trafo'
    # See https://lists.gnu.org/archive/html/bug-ncurses/2014-07/msg00022.html
    # and https://trac.sagemath.org/ticket/18301
    # Disable linemarker output of cpp
    ENV.append "CPPFLAGS", "-P"

    (lib/"pkgconfig").mkpath

    system "./configure", "--prefix=#{prefix}",
                          "--enable-pc-files",
                          "--with-pkg-config-libdir=#{lib}/pkgconfig",
                          "--enable-sigwinch",
                          "--enable-symlinks",
                          "--enable-widec",
                          "--mandir=#{man}",
                          "--with-manpage-format=normal",
                          "--with-shared",
                          "--with-gpm=no"
    system "make"
    ENV.deparallelize
    system "make", "install"
    make_libncurses_symlinks

    prefix.install "test"
    (prefix/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.to_s.split(".")[0]

    %w[form menu ncurses panel].each do |name|
      lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.dylib"
      lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.#{major}.dylib"
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

    lib.install_symlink "libncurses++w.a" => "libncurses++.a"
    lib.install_symlink "libncurses.a" => "libcurses.a"
    lib.install_symlink "libncurses.dylib" => "libcurses.dylib"

    (lib/"pkgconfig").install_symlink "ncursesw.pc" => "ncurses.pc"

    bin.install_symlink "ncursesw#{major}-config" => "ncurses#{major}-config"

    include.install_symlink [
      "ncursesw/curses.h", "ncursesw/form.h", "ncursesw/ncurses.h",
      "ncursesw/panel.h", "ncursesw/term.h", "ncursesw/termcap.h"
    ]
  end

  test do
    ENV["TERM"] = "xterm"

    system prefix/"test/configure", "--prefix=#{testpath}/test",
                                    "--with-curses-dir=#{prefix}"
    system "make", "install"

    system testpath/"test/bin/keynames"
    system testpath/"test/bin/test_arrays"
    system testpath/"test/bin/test_vidputs"
  end
end
