require 'singleton'

module NxtErrorRegistry
  class Registry
    STORE = {}
    include Singleton

    delegate_missing_to :STORE
    delegate :to_s, :inspect, to: :STORE

    def flat
      STORE.values.reduce({}, :merge)
    end

    def codes
      flat.map { |_, entry| entry.fetch(:code) }
    end

    def entries_by_codes
      flat.inject({}) do |acc, (_, entry)|
        code = entry.fetch(:code)
        (acc[code] ||= []) << entry
        acc
      end
    end

    def duplicate_codes
      entries_by_codes.select { |_, v| v.size > 1 }
    end
  end
end