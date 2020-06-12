module PgBucketImport
  class ConfigGenerator < Rails::Generators::Base
    def create_initializer_file
      code = <<~RUBY
        PgBucketImport.configure(
          # key: Rails.application.credentials.spaces&.dig(:key),
          # secret: Rails.application.credentials.spaces&.dig(:secret),
          # bucket: Rails.application.credentials.spaces&.dig(:bucket),
          # endpoint: Rails.application.credentials.spaces&.dig(:endpoint),
          # reset_enabled: true,
          # folder: Rails.application.credentials.spaces&.dig(:folder),
          # database: ActiveRecord::Base.connection_config[:database],
          # username: ActiveRecord::Base.connection_config[:username],
          # host: ActiveRecord::Base.connection_config[:host],
          # port: ActiveRecord::Base.connection_config[:port] || 5432
        )
      RUBY
      create_file "config/initializers/pg_bucket_import.rb", code
    end
  end
end
