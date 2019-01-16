class Packer < Formula
  homepage "https://www.packer.io/"
  url "https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_darwin_amd64.zip"
  version "1.3.3"
  sha256 "6ffbb13bee76e02f7b065955307d454b14773feee9fcfc3b5dd96ed154b931c4"


  def install
    bin.install "packer"
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<~EOS
      {
        "builders": [{
          "type": "amazon-ebs",
          "region": "us-east-1",
          "source_ami": "ami-59a4a230",
          "instance_type": "m3.medium",
          "ssh_username": "ubuntu",
          "ami_name": "homebrew packer test  {{timestamp}}"
        }],
        "provisioners": [{
          "type": "shell",
          "inline": [
            "sleep 30",
            "sudo apt-get update"
          ]
        }]
      }
    EOS
    system "#{bin}/packer", "validate", "-syntax-only", minimal
  end
end
