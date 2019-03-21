module NxtErrorRegistry
  class DefaultCodeValidator
    CodeAlreadyTakenError = Class.new(StandardError)
    CodeAlreadyTakenError = Class.new(StandardError)
    InvalidCodeFormatError = Class.new(StandardError)
    CodeNotInSequence = Class.new(StandardError)

    FORMAT = /\A\d{3}\.\d{3}\z/

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
      duplicates = registry.duplicate_codes
      return if duplicates.empty?

      raise CodeAlreadyTakenError, "The following codes are duplicated: #{duplicates.keys.join(',')}"
    end

    # TODO - Put this in a rake task to find codes that are not in sequence?!
    def validate_codes_in_sequence
      codes_as_ids.in_groups_of(2).each do |tuple|
        next unless tuple.last
        next if tuple.first + 1 == tuple.last

        raise_codes_not_in_sequence_error(tuple.first, tuple.last)
      end
    end

    def codes_as_ids
      registry.codes.map { |code| Integer(code.delete('.')) }.sort
    end

    def raise_codes_not_in_sequence_error(code, other_code)
      code_entry = registry.entries_by_codes.fetch(id_to_code(code))
      other_code_entry = registry.entries_by_codes.fetch(id_to_code(other_code))

      raise CodeNotInSequence, "The codes of #{code_entry} and #{other_code_entry} are not in sequence"
    end

    def id_to_code(code)
      "#{code.to_s[0..2]}.#{code.to_s[3..-1]}"
    end

    def registry
      NxtErrorRegistry::Registry.instance
    end
  end
end