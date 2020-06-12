module PgBucketImport
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), "tasks/*.rake")].each { |f| load f }
    end

    generators do
      require File.join(File.dirname(__FILE__), "generators/config_generator.rb")
    end
  end
end
