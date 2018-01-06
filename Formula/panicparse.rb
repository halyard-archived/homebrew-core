class Panicparse < Formula
  desc "Panicparse"
  homepage "https://github.com/maruel/panicparse"

  url "https://github.com/maruel/panicparse/archive/v1.0.2.tar.gz"
  sha256 "98d4e2451a6813e6b42c004cb9537099a924d916ba2dbcf048f62e484aa883f6"
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
