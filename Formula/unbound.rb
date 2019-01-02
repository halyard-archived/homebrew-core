class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://www.unbound.net/downloads/unbound-1.8.3.tar.gz"
  sha256 "2b692b8311edfad41e7d0380aac34576060d4176add81dc5db419c79b2a4cecc"

  depends_on "libevent"
  depends_on "openssl"

  depends_on "python" => :optional
  depends_on "swig" if build.with?("python")


  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    if build.with? "python"
      ENV.prepend "LDFLAGS", `python-config --ldflags`.chomp
      ENV.prepend "PYTHON_VERSION", "2.7"

      args << "--with-pyunbound"
      args << "--with-pythonmodule"
      args << "PYTHON_SITE_PKG=#{lib}/python2.7/site-packages"
    end

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed?
    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "test"
    system "make", "install"
  end

  def post_install
    conf = etc/"unbound/unbound.conf"
    return unless conf.exist?
    return unless conf.read.include?('username: "@@HOMEBREW-UNBOUND-USER@@"')
    inreplace conf, 'username: "@@HOMEBREW-UNBOUND-USER@@"',
                    "username: \"#{ENV["USER"]}\""
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/unbound</string>
          <string>-d</string>
          <string>-c</string>
          <string>#{etc}/unbound/unbound.conf</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end
