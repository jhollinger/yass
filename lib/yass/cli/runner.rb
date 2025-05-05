module YASS
  module CLI
    module Runner
      def self.build(config)
        YASS::Generator.new(config).generate!
        return 0
      rescue => e
        config.stderr.puts "#{e.class.name}: #{e.message}"
        return 1
      end
    end
  end
end
