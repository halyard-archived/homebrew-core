class Phantomjs < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  url "https://github.com/ariya/phantomjs.git",
      :tag => "2.1.3",
      :revision => "ca5a6c377d408366d0d4b8ecf4539b628420c8f1"

  # Fix a variant of QTBUG-62266 in included Qt source
  # https://github.com/ariya/phantomjs/issues/15116
  if MacOS.version >= :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/33dbb45f82/phantomjs/QTBUG-62266.diff"
      sha256 "d47b52c6a932139a448340244f66ea126412d210ab94dc19da7c468afaf5f45a"
    end
  end

  depends_on MinimumMacOSRequirement => :lion
  depends_on :xcode => :build
  depends_on "openssl"


  def install
    ENV["OPENSSL"] = Formula["openssl"].opt_prefix
    system "./build.py", "--confirm", "--jobs", ENV.make_jobs
    bin.install "bin/phantomjs"
    pkgshare.install "examples"
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS
      console.log("hello");
      phantom.exit();
    EOS

    assert_equal "hello", shell_output("#{bin}/phantomjs #{path}").strip
  end
end
