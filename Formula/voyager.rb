class Voyager < Formula
  desc "Helper for connecting to AWS accounts"
  homepage "https://github.com/akerl/voyager"

  url "https://github.com/akerl/voyager/releases/download/v0.8.2/voyager_darwin"
  version "0.8.2"
  sha256 "d35dba3f175ea03ec4b891ff51fb4ca65f15a159d2163fa35e98069a27edcebb"

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
