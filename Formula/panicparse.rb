class Panicparse < Formula
  desc "Panicparse"
  homepage "https://github.com/maruel/panicparse"

  url "https://github.com/maruel/panicparse/archive/v1.1.1.tar.gz"
  sha256 "4ff457e2da6b8515ec66ec1a21028f627c3f5df5c85f0bf45b026410e6229892"
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
