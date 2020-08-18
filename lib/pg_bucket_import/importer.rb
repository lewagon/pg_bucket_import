require "socket"
require "aws-sdk-s3"
require_relative "configuration"

module PgBucketImport
  class Importer
    def initialize
      @options = Configuration.instance.options
      @options.each do |k, v|
        instance_variable_set("@#{k}".to_sym, v)
      end
      check_creds
      @client = init_client
    end

    def reset_enabled?
      @reset_enabled
    end

    def download_latest
      backups = @client.list_objects({bucket: @bucket, prefix: @folder})
      latest = backups.contents.max_by(&:last_modified).key.to_s
      @target = latest.gsub(/#{Regexp.quote(@folder)}\//, "")

      @client.get_object(
        bucket: @bucket,
        key: latest,
        response_target: Rails.root.join("tmp", @target)
      )
      puts "✅ Successfully downloaded latest backup from #{@target}"
      true
    rescue Aws::S3::Errors::NoSuchKey
      puts "❌ Could not find backup file, check Digital Ocean Spaces"
      false
    end

    # This will also remove the dump file from local drive
    def import_latest
      path = Rails.root.join("tmp", @target)
      worked = system <<~BASH
        pg_restore --username=#{@username} --host=#{@host} --port=#{@port} --dbname=#{@database} \
        --no-owner --verbose --no-acl #{path}
      BASH
      if worked
        puts "✅ Successfully imported #{@target} into #{@database}"
        puts "Removing the dump file..."
        File.delete(path)
        puts "✅ Removed dump at #{path}"
      else
        puts "❌Failure to import last DB backup, keeping the dump file at #{path}" \
             " Remove manually if necessary"
      end
    end

    def warn
      puts "🙋‍♀️ This will completely reset your #{Rails.env} database and replace it with latest production values. [y/n]"
      print "> "
      answer = STDIN.gets.chomp
      unless answer.downcase == "y" || answer.downcase == "Yes"
        exit(0)
      end
    end

    private

    def check_creds
      if [@key, @secret, @bucket, @endpoint].any?(&:blank?)
        puts "❌ Digital Ocean Spaces s3-style access keys are missing in Rails credentials"
        exit(1)
      end
      true
    end

    def init_client
      Aws::S3::Client.new(
        access_key_id: @key,
        secret_access_key: @secret,
        endpoint: @endpoint,
        region: "us-east-1" # Has to stay like that for s3 compatibility
      )
    end
  end
end
