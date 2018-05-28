class Dapper < Formula
  desc "Handle packed Stylish theme exports"
  homepage "https://github.com/akerl/dapper"

  version "0.0.2"
  url "https://github.com/akerl/dapper/releases/download/#{version}/dapper_darwin"
  sha256 "93fba0f3208bff38bd9ff10d70829cf9a12c578b1aeab534a12d921823b7f975"

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
