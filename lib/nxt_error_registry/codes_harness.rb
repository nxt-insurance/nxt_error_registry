require 'singleton'

module NxtErrorRegistry
  class CodesHarness
    CodeAlreadyRegistered = Class.new(StandardError)
    include Singleton

    def generate_code
      generate_next_code
    rescue CodeAlreadyRegistered
      retry
    end

    def generate_next_code
      new_code = SecureRandom.uuid
      return new_code unless registered_codes.include?(new_code)

      raise CodeAlreadyRegistered, "#{new_code} already registered"
    end

    def registered_codes
      registry.codes
    end

    def registry
      NxtErrorRegistry::Registry.instance
    end
  end
end
