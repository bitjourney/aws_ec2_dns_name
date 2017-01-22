# frozen_string_literal: true
Gem::Specification.new do |spec|
  spec.name          = "aws_ec2_dns_name"
  spec.version       = "0.1.3"
  spec.authors       = ["Michikawa Masayoshi"]
  spec.email         = ["michikawa.masayoshi@gmail.com"]

  spec.summary       = "Simpler interface to AWS EC2 dns name"
  spec.description   = "Simpler interface to AWS EC2 dns name"
  spec.homepage      = "https://github.com/bitjourney/aws_ec2_dns_name"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk", "~> 2.6"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop"
end
