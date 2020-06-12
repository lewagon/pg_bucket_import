module PgBucketImport
  def self.configure(opts = {})
    Configuration.instance.configure(opts)
  end

  class Configuration
    attr_reader :options
    include Singleton

    def configure(opts)
      @options = opts
    end
  end
end
