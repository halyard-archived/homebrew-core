class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"

  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.9/tcl8.6.9-src.tar.gz"
  version "8.6.9"
  sha256 "ad0cd2de2c87b9ba8086b43957a0de3eb2eb565c7159d5f53ccbba3feb915f4e"


  option "without-tcllib", "Don't build tcllib (utility modules)"
  option "without-tk", "Don't build the Tk (window toolkit)"

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.9/tk8.6.9-src.tar.gz"
    version "8.6.9"
    sha256 "d3f9161e8ba0f107fe8d4df1f6d3a14c30cc3512dfc12a795daa367a27660dac"
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.19/tcllib-1.19.tar.gz"
    sha256 "01fe87cf1855b96866cf5394b6a786fd40b314022714b34110aeb6af545f6a9c"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh#{version.to_f}", bin/"tclsh"
    end

    if build.with? "tk"
      ENV.prepend_path "PATH", bin # so that tk finds our new tclsh

      resource("tk").stage do
        cd "unix" do
          system "./configure", *args, "--enable-aqua=yes",
                                "--without-x", "--with-tcl=#{lib}"
          system "make"
          system "make", "install"
          system "make", "install-private-headers"
          ln_s bin/"wish#{version.to_f}", bin/"wish"
        end
      end
    end

    if build.with? "tcllib"
      resource("tcllib").stage do
        system "./configure", "--prefix=#{prefix}",
                              "--mandir=#{man}"
        system "make", "install"
      end
    end
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp
  end
end
