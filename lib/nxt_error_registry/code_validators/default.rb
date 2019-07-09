module NxtErrorRegistry
  module CodeValidators
    class Default
      CodeAlreadyTakenError = Class.new(StandardError)
      InvalidCodeFormatError = Class.new(StandardError)

      def self.code_format=(format)
        @format = format
      end

      def self.code_format
        @format || (raise ArgumentError, "Format never was set")
      end

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
        return if code =~ self.class.code_format
        raise InvalidCodeFormatError, "Code #{code} for name #{name} violates format #{FORMAT} in context: #{context}"
      end

      def validate_code_uniqueness
        duplicates = registry.duplicate_codes
        return if duplicates.empty?

        raise CodeAlreadyTakenError, "The following codes are duplicated: #{duplicates.keys.join(',')}"
      end

      def registry
        NxtErrorRegistry::Registry.instance
      end
    end
  end
end