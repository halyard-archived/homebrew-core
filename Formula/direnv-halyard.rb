class DirenvHalyard < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.13.2.tar.gz"
  sha256 "04fdbd3fe7ddf496a3da41cb6e767100d8d6f6b52fef9e2217c9e330b0e6257d"
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
