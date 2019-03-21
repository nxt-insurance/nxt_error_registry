module NxtErrorRegistry
  class CodesHarness
    def generate_code
      puts "WARNING: Codes are not in sequence: #{codes_not_in_sequence}" if codes_not_in_sequence.any?

      last_id = codes_as_ids.last
      return '100.000' unless last_id

      next_id = last_id + 1
      id_to_code(next_id)
    end

    def codes_not_in_sequence
      previous_id = nil

      codes_as_ids.inject([]) do |acc, id|
        if !previous_id || previous_id + 1 == id
          previous_id = id
          acc
        else
          acc << [previous_id, id]
          previous_id = id
          acc
        end
      end
    end

    def codes_as_ids
      registry.codes.map { |code| Integer(code.delete('.')) }.sort
    end

    def id_to_code(code)
      "#{code.to_s[0..2]}.#{code.to_s[3..-1]}"
    end

    def registry
      NxtErrorRegistry::Registry.instance
    end
  end
end