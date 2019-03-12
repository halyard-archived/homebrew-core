class Voyager < Formula
  desc "Helper for connecting to AWS accounts"
  homepage "https://github.com/akerl/voyager"

  url "https://github.com/akerl/voyager/releases/download/v0.8.3/voyager_darwin"
  version "0.8.3"
  sha256 "07915224ed4cf8a7ef882c8b7618e19350761d906b73c9552d70a03b2d2f12aa"

  head do
    url "https://github.com/akerl/voyager.git"
    depends_on "go" => :build
  end

  def install
    if build.head?
      system "make"
      mv "bin/voyager_darwin", "voyager"
    else
      mv "voyager_darwin", "voyager"
    end
    bin.install "voyager"
  end

  test do
    system bin/"voyager", "version"
  end
end
