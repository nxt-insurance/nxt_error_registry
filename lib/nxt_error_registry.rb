require "active_support/all"
require "nxt_error_registry/version"
require "nxt_error_registry/registry"
require "nxt_error_registry/code_generators"
require "nxt_error_registry/code_generators/default"
require "nxt_error_registry/code_validators"
require "nxt_error_registry/code_validators/default"
require 'railtie' if defined?(Rails)

module NxtErrorRegistry
  RegistrationError = Class.new(StandardError)
  CodeValidator = CodeValidators::Default

  def register_error(name, type:, code:, **opts, &block)
    raise_name_not_a_symbol_error(name) unless name.is_a?(Symbol)
    raise_registration_error(name) if const_defined?(name)

    error_class = Class.new(type, &block)
    error_class.define_singleton_method :code, -> { code }
    error_class.define_singleton_method :options do
      # the superclass "type" may not have defined options yet
      inherited_options = type.try(:options) || {}
      inherited_options.merge(opts)
    end

    const_set(name, error_class)
    entry = { code: code, error_class: error_class, type: type, name: name, namespace: self.to_s, opts: opts }
    error_registry[name.to_s] = entry

    # This depends on duplicate entries so has to come last
    validate_code(name, type, code)
  end

  private

  def validate_code(name, type, code)
    CodeValidator.new(name, type, code, self).validate
  end

  def error_registry
    @error_registry ||= begin
      ::NxtErrorRegistry::Registry.instance[self.to_s] ||= { }
      ::NxtErrorRegistry::Registry.instance[self.to_s]
    end
  end

  def raise_registration_error(name)
    raise RegistrationError, "#{name} was already registered in #{self}"
  end

  def raise_name_not_a_symbol_error(name)
    raise ArgumentError, "Error name '#{name}' must be a symbol"
  end
end
