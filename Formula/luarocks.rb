class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.0.3.tar.gz"
  sha256 "f9a3fca236c87db55bc128a182ff605731ca15b43b1c4942d98f5e34acc88a6e"

  depends_on "lua"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--rocks-tree=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    ENV["LUA_PATH"] = "#{testpath}/share/lua/5.3/?.lua"
    ENV["LUA_CPATH"] = "#{testpath}/lib/lua/5.3/?.so"

    (testpath/"lfs_53test.lua").write <<~EOS
      require("lfs")
      print(lfs.currentdir())
    EOS

    system "#{bin}/luarocks", "--tree=#{testpath}", "install", "luafilesystem"
    system "lua", "-e", "require('lfs')"
    assert_match testpath.to_s, shell_output("lua lfs_53test.lua")
  end
end
