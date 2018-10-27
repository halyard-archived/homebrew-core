class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.3.tar.xz"
  sha256 "ef8654313bfb0ca92e27cf579efb2d9b17e53505e615bf3d71a51aef44e56a5f"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "perl"
  depends_on "python@2"

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{etc}/openssl/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DRUBY_EXECUTABLE=/usr/bin/ruby
      -DRUBY_LIB=/usr/lib/libruby.dylib
      -DENABLE_ASPELL=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
