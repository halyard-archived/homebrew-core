class Dapper < Formula
  desc "Handle packed Stylish theme exports"
  homepage "https://github.com/akerl/dapper"

  url "https://github.com/akerl/dapper/releases/download/v0.1.0/dapper_darwin"
  version "0.1.0"
  sha256 "28df222019eac45b6a90670b71a826a0f3d4ac1cd8c94007f190c442c16fdcb6"

  head do
    url "https://github.com/akerl/dapper.git"
    depends_on "go" => :build
  end

  def install
    if build.head?
      system "make"
      mv "bin/dapper_darwin", "dapper"
    else
      mv "dapper_darwin", "dapper"
    end
    bin.install "dapper"
  end

  test do
    system bin/"dapper", "version"
  end
end
