class Panicparse < Formula
  desc "Panicparse"
  homepage "https://github.com/maruel/panicparse"

  url "https://github.com/maruel/panicparse/archive/v1.1.0.tar.gz"
  sha256 "d5169efffbc459878ecf3b3d80b90e03c21b95ff0908b63b626dfc927458b86a"
  head "https://github.com/maruel/panicparse.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/maruel/panicparse"
    bin_path.install Dir["*"]
    cd bin_path do
      system "go", "build", "-o", bin/"pp", "."
    end
  end

  test do
    (testpath/"test.txt").write "hello world"
    system "#{bin}/pp", "test.txt"
  end
end
