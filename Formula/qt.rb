# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtHalyard < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  version "5.10.0"
  url "https://download.qt.io/official_releases/qt/#{version.to_s.split('.').take(2).join('.')}/#{version}/single/qt-everywhere-src-#{version}.tar.xz"
  sha256 "cb69eb2d9175fc077d75156427647551d84e73dd253ab4620a76d778229ed3f3"
  head "https://code.qt.io/qt/qt5.git", :branch => "5.9", :shallow => false

  keg_only "Qt 5 has CMake issues when linked"

  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"

  depends_on "pkg-config-halyard" => :build
  depends_on :xcode => :build

  conflicts_with "qt", :because => "qt-halyard replaces qt"

  def install
    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -system-zlib
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake tests
      -no-rpath
      -pkg-config
      -dbus-runtime
    ]

    args << "-nomake" << "examples" if build.without? "examples"

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    if build.with? "docs"
      system "make", "docs"
      system "make", "install_docs"
    end

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats; <<~EOS
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_predicate testpath/"hello", :exist?
    assert_predicate testpath/"main.o", :exist?
    system "./hello"
  end
end
