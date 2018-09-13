class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/releases/download/3.1.0/noti3.1.0.darwin-amd64.tar.gz"
  version "3.1.0"
  sha256 "ddfd003f36256c96b75165c30a3cd4e32ec61b33809c677766a25b2161874456"

  def install
    bin.install "noti"
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
