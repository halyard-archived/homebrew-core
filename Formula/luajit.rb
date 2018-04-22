class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  url "https://luajit.org/download/LuaJIT-2.0.5.tar.gz"
  sha256 "874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979"
  revision 3

  option "with-debug", "Build with debugging symbols"
  option "with-52compat", "Build with additional Lua 5.2 compatibility"

  resource "luarocks" do
    url "https://luarocks.org/releases/luarocks-2.4.4.tar.gz"
    sha256 "3938df33de33752ff2c526e604410af3dceb4b7ff06a770bc4a240de80a1f934"
  end

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.change_make_var! "CCOPT_x86", ""
    end

    ENV.O2 # Respect the developer's choice.

    args = %W[PREFIX=#{prefix}]

    cflags = []
    cflags << "-DLUAJIT_ENABLE_LUA52COMPAT" if build.with? "52compat"
    cflags << "-DLUAJIT_ENABLE_GC64" if !build.stable? && build.with?("gc64")

    args << "XCFLAGS=#{cflags.join(" ")}" unless cflags.empty?

    # This doesn't yet work under superenv because it removes "-g"
    args << "CCDEBUG=-g" if build.with? "debug"

    # The development branch of LuaJIT normally does not install "luajit".
    args << "INSTALL_TNAME=luajit" if build.devel?

    system "make", "amalg", *args
    system "make", "install", *args

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/"libluajit-5.1.dylib" => "libluajit.dylib"
    lib.install_symlink lib/"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib/"pkgconfig/luajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}/share/lua/${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}/share/lua/${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}/${multilib}/lua/${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}/${multilib}/lua/${abiver}"
      if build.without? "gc64"
        s.gsub! "Libs:",
                "Libs: -pagezero_size 10000 -image_base 100000000"
      end
    end

    # Having an empty Lua dir in lib/share can mess with other Homebrew Luas.
    %W[#{lib}/lua #{share}/lua].each { |d| rm_rf d }

    # This resource must be handled after the main install, since there's a lua dep
    # Keeping it in install rather than postinstall means we can bottle.
    resource("luarocks").stage do
      ENV.prepend_path "PATH", bin

      system "./configure", "--prefix=#{libexec}", "--rocks-tree=#{HOMEBREW_PREFIX}",
                            "--sysconfdir=#{etc}/luarocks51", "--with-lua=#{prefix}",
                            "--versioned-rocks-dir", "--lua-suffix=jit",
                            "--with-lua-include=#{include}/luajit-2.0"
      system "make", "build"
      system "make", "install"

      (pkgshare/"5.1/luarocks").install_symlink Dir["#{libexec}/share/lua/5.1/lua
rocks/*"]
      bin.install_symlink libexec/"bin/luarocks-5.1"
      bin.install_symlink libexec/"bin/luarocks-admin-5.1"

      # This block ensures luarock exec scripts don't break across updates.
      inreplace libexec/"share/lua/5.1/luarocks/site_config.lua" do |s|
        s.gsub! libexec.to_s, opt_libexec
        s.gsub! include.to_s, "#{HOMEBREW_PREFIX}/include"
        s.gsub! lib.to_s, "#{HOMEBREW_PREFIX}/lib"
        s.gsub! bin.to_s, "#{HOMEBREW_PREFIX}/bin"
      end
    end
  end

  test do
    system "#{bin}/luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
