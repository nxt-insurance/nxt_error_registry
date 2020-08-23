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
      chars = SecureRandom.hex(4).chars
      new_code = "#{chars[0..2].join}.#{chars[3..-1].join}"
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
