class DirenvHalyard < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.14.0.tar.gz"
  sha256 "917838827cb753153b91cb2d10c0d7c20cbaa85aa2dde520ee23653a74268ccd"
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
