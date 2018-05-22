class Dapper < Formula
  desc "Handle packed Stylish theme exports"
  homepage "https://github.com/akerl/dapper"

  version "0.0.1"
  url "https://github.com/akerl/dapper/releases/download/#{version}/dapper_darwin"
  sha256 "5f096e26fea92dccaf9c03502ec3f224edd17c984175b941f4aa174862ced815"

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
