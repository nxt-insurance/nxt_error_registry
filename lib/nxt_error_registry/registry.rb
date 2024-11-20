module NxtErrorRegistry
  class Registry
    def self.instance
      @instance ||= send(:new)
    end

    # Usually we don't want this to be initialized other than through instance
    private_class_method :new

    def initialize
      @store = {}
    end

    attr_reader :store

    delegate_missing_to :store
    delegate :to_s, :inspect, to: :store

    def flat
      values.map(&:values).flatten
    end

    def codes
      flat.map { |entry| entry.fetch(:code) }
    end

    def entries_by_codes
      flat.each_with_object({}) do |entry, acc|
        code = entry.fetch(:code)
        (acc[code] ||= []) << entry
      end
    end

    def duplicated_codes
      entries_by_codes.select { |_, v| v.size > 1 }
    end
  end
end
