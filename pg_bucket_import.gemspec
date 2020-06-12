require_relative "lib/pg_bucket_import/version"

Gem::Specification.new do |spec|
  spec.name = "pg_bucket_import"
  spec.version = PgBucketImport::VERSION
  spec.authors = ["Andy B"]
  spec.email = ["andybarnov@gmail.com"]

  spec.summary = "A Rake task to import Postgres dumps from S3 buckets into develepment DB."
  spec.description = "A Rake task to import Postgres dumps from S3 buckets into develepment DB."
  spec.homepage = "https://github.com/lewagon/pg_bucket_import"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lewagon/pg_bucket_import"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-s3", "~> 1.67"
end
