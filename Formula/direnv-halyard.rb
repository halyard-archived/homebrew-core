class DirenvHalyard < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.13.3.tar.gz"
  sha256 "2d5569ef08a919e02d8b229b8f71ca01a0f3920e7e14f0b10c0df76bb4ea57a1"
  head "https://github.com/direnv/direnv.git"

  depends_on "go-halyard" => :build

  conflicts_with 'direnv', :because => 'direnv-halyard replaces direnv'

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
