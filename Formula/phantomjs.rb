class Phantomjs < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  url "https://github.com/ariya/phantomjs.git",
      :tag => "2.1.1",
      :revision => "d9cda3dcd26b0e463533c5cc96e39c0f39fc32c1"

  # Fixes build.py for non-standard Homebrew prefixes.  Applied
  # upstream, can be removed in next release.
  patch do
    url "https://github.com/ariya/phantomjs/commit/6090f5457d2051ab374264efa18f655fa3e15e79.diff?full_index=1"
    sha256 "6ff047216fa76c2350f8fd20497b1264904eda0d6cade9bf2ebb3843740cd03f"
  end

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
