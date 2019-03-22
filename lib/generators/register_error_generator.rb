class RegisterErrorGenerator < Rails::Generators::Base
  desc "This generator creates a register_error statement to include in your code"
  class_option :type, type: :string, default: 'ErrorType'

  def register_error
    Rails.application.eager_load!
    type = options['type'].camelcase
    harness = NxtErrorRegistry::CodesHarness.instance
    code = harness.generate_code
    puts '----------------------------------------------'
    puts "register_error :#{type}, code: '#{code}'"
    puts '----------------------------------------------'
  end
end