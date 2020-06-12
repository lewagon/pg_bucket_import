require "pg_bucket_import/version"
require "pg_bucket_import/railtie" if defined?(Rails::Railtie)
require "pg_bucket_import/configuration"

module PgBucketImport
  class Error < StandardError; end
  # Your code goes here...
end
