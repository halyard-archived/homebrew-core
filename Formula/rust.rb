class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  url "https://static.rust-lang.org/dist/rustc-1.28.0-src.tar.gz"
  sha256 "1d5a81729c6f23a0a23b584dd249e35abe9c6f7569cee967cc42b1758ecd6486"

  option "with-llvm", "Build with brewed LLVM. By default, Rust's LLVM will be used."

  depends_on "cmake" => :build
  depends_on "pkg-config"
  depends_on "llvm" => :optional
  depends_on "openssl@1.0"
  depends_on "libssh2"

  resource "cargo" do
    url "https://github.com/rust-lang/cargo.git", :tag => "0.29.0",
        :revision => "96a2c7d16249cb47c61c887fc95ca8be60e7ef0a"
  end

  resource "racer" do
    url "https://github.com/racer-rust/racer/archive/2.1.4.tar.gz"
    sha256 "30f0e0cbbf53c13eceda5e51dd8e1366d787d70b0dcffaa67543844e4b31594d"
  end

  resource "cargobootstrap" do
    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
    url "https://static.rust-lang.org/dist/cargo-0.28.0-x86_64-apple-darwin.tar.gz"
    sha256 "bc995c0710913b21ac979aa911669fbb1a11fbdda52eb0b4bb5e72fbcbb82085"
  end

  # According to the official readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def install
    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Prevent cargo from linking against a different library (like openssl@1.1)
    # from libssh2 and causing segfaults
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl@1.0"].opt_include
    ENV["OPENSSL_LIB_DIR"] = Formula["openssl@1.0"].opt_lib

    # Fix build failure for cmake v0.1.24 "error: internal compiler error:
    # src/librustc/ty/subst.rs:127: impossible case reached" on 10.11, and for
    # libgit2-sys-0.6.12 "fatal error: 'os/availability.h' file not found
    # #include <os/availability.h>" on 10.11 and "SecTrust.h:170:67: error:
    # expected ';' after top level declarator" among other errors on 10.12
    ENV["SDKROOT"] = MacOS.sdk_path

    args = ["--prefix=#{prefix}"]
    args << "--llvm-root=#{Formula["llvm"].opt_prefix}" if build.with? "llvm"
    args << "--release-channel=stable"
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    resource("cargo").stage do
      ENV["RUSTC"] = bin/"rustc"
      system "cargo", "build", "--release", "--verbose"
      bin.install "target/release/cargo"
    end

    resource("racer").stage do
      ENV.prepend_path "PATH", bin
      cargo_home = buildpath/"cargo_home"
      cargo_home.mkpath
      ENV["CARGO_HOME"] = cargo_home
      system bin/"cargo", "build", "--release", "--verbose"
      (libexec/"bin").install "target/release/racer"
      (bin/"racer").write_env_script(libexec/"bin/racer", :RUST_SRC_PATH => pkgshare/"rust_src")
    end

    # Remove any binary files; as Homebrew will run ranlib on them and barf.
    rm_rf Dir["src/{llvm,llvm-emscripten,test,librustdoc,etc/snapshot.pyc}"]
    (pkgshare/"rust_src").install Dir["src/*"]

    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      chmod 0444, dylib
    end
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
