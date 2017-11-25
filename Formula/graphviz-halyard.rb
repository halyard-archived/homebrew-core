class GraphvizHalyard < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.40.1.tar.gz"
  sha256 "ca5218fade0204d59947126c38439f432853543b0818d9d728c589dfe7f3a421"
  version_scheme 1

  head do
    url "https://github.com/ellson/graphviz.git"

    depends_on "automake-halyard" => :build
    depends_on "autoconf-halyard" => :build
    depends_on "libtool-halyard" => :build
  end

  option "with-bindings", "Build Perl/Python/Ruby/etc. bindings"
  option "with-pango", "Build with Pango/Cairo for alternate PDF output"
  option "with-app", "Build GraphViz.app (requires full XCode install)"
  option "with-gts", "Build with GNU GTS support (required by prism)"

  depends_on "pkg-config-halyard" => :build
  depends_on :xcode => :build if build.with? "app"
  depends_on "libtool-halyard" => :run
  depends_on "pango-halyard" => :optional
  depends_on "gts-halyard" => :optional
  depends_on "librsvg-halyard" => :optional
  depends_on "freetype-halyard" => :optional
  depends_on :x11 => :optional
  depends_on "gd-halyard"
  depends_on "libpng-halyard"

  if build.with? "bindings"
    depends_on "swig-halyard" => :build
    depends_on "python-halyard"
    depends_on "java-halyard"
    depends_on "ruby-halyard"
  end

  conflicts_with "graphviz", :because => "graphviz-halyard replaces graphviz"

  def install
    # Only needed when using superenv, which causes qfrexp and qldexp to be
    # falsely detected as available. The problem is triggered by
    #   args << "-#{ENV["HOMEBREW_OPTIMIZATION_LEVEL"]}"
    # during argument refurbishment of cflags.
    # https://github.com/Homebrew/brew/blob/ab060c9/Library/Homebrew/shims/super/cc#L241
    # https://github.com/Homebrew/legacy-homebrew/issues/14566
    # Alternative fixes include using stdenv or using "xcrun make"
    inreplace "lib/sfio/features/sfio", "lib qfrexp\nlib qldexp\n", ""

    if build.with? "bindings"
      # the ruby pkg-config file is version specific
      inreplace "configure" do |s|
        s.gsub! "ruby-1.9", "ruby-#{Formula["ruby-halyard"].stable.version.to_f}"
        s.gsub! "if test `$SWIG -php7 2>&1", "if test `$SWIG -php0 2>&1"
      end
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-qt
      --with-quartz
      --disable-php
    ]
    args << "--with-gts" if build.with? "gts"
    args << "--disable-swig" if build.without? "bindings"
    args << "--without-pangocairo" if build.without? "pango"
    args << "--without-freetype2" if build.without? "freetype"
    args << "--without-x" if build.without? "x11"
    args << "--without-rsvg" if build.without? "librsvg"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"

    if build.with? "app"
      cd "macosx" do
        xcodebuild "SDKROOT=#{MacOS.sdk_path}", "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}",
                   "ONLY_ACTIVE_ARCH=YES", "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
      end
      prefix.install "macosx/build/Release/Graphviz.app"
    end

    (bin/"gvmap.sh").unlink
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
