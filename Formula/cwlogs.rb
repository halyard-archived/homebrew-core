class Cwlogs < Formula
  desc "Simple CLI for viewing cloudwatch logs"
  homepage "https://github.com/segmentio/cwlogs"

  version "1.2.0"
  url "https://github.com/segmentio/cwlogs/releases/download/v#{version}/cwlogs-v#{version}-darwin-amd64"
  sha256 "debb6f10ba60aaf9a0a8bb6f2dfb4f424f36e848ea0c693a6b59e29cb804de43"

  def install
    bin.install "cwlogs-v#{version}-darwin-amd64" => "cwlogs"
  end
end
