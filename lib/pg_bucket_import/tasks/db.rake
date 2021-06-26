require File.join(File.dirname(__FILE__), "../importer.rb")

namespace :db do
  desc "Reset the db and import the latest dump from an S3 bucket"
  task reset_and_import_from_bucket: :environment do
    if Rails.env.production?
      puts "Make sure to use pg_bucket_import in development environment only"
      return
    end

    importer = PgBucketImport::Importer.new
    importer.warn
    ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] = "1"
    Rake::Task["db:reset"].invoke
    importer.import_latest if importer.download_latest
  end

  desc "Import the latest dump from an S3 bucket without DB reset"
  task import_from_bucket: :environment do
    if Rails.env.production?
      puts "Make sure to use pg_bucket_import in development environment only"
      return
    end

    importer = PgBucketImport::Importer.new
    importer.import_latest if importer.download_latest
  end

  desc "Download the latest dump from an S3 bucket"
  task download_from_bucket: :environment do
    if Rails.env.production?
      puts "Make sure to use pg_bucket_import in development environment only"
      return
    end

    PgBucketImport::Importer.new.download_latest
  end
end
