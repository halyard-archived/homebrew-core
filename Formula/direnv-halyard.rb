class DirenvHalyard < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.13.1.tar.gz"
  sha256 "eea1d4eb4c95c1a6d41bb05a35ed0e106d497f10761e5d0e1c3b87d07c70c7b4"
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
