module NxtErrorRegistry
  class DefaultCodeValidator
    CodeAlreadyTakenError = Class.new(StandardError)
    InvalidCodeFormatError = Class.new(StandardError)

    FORMAT = /\A[a-zA-Z0-9-]{36}\z/

    def initialize(name, type, code, context)
      @name = name
      @type = type
      @code = code
      @context = context
    end

    def validate
      validate_code_format
      validate_code_uniqueness

      code
    end

    private

    attr_reader :name, :type, :code, :context

    def validate_code_format
      return if code =~ FORMAT

      raise InvalidCodeFormatError, "Code #{code} for name #{name} violates format #{FORMAT} in context: #{context}"
    end

    def validate_code_uniqueness
      duplicates = registry.duplicated_codes
      return if duplicates.empty?

      raise CodeAlreadyTakenError, "The following codes are duplicated: #{duplicates.keys.join(',')}"
    end

    def registry
      NxtErrorRegistry::Registry.instance
    end
  end
end
