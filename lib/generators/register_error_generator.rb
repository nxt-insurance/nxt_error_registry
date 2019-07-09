class RegisterErrorGenerator < Rails::Generators::Base
  desc "This generator creates a register_error statement to include in your code"
  class_option :name, type: :string, default: 'ErrorName'
  class_option :type, type: :string, default: 'ParentClass'

  def register_error
    Rails.application.eager_load!
    name = options['name'].camelcase
    type = options['type'].camelcase
    harness = NxtErrorRegistry::CodeGenerators::Default.instance
    code = harness.generate_code
    puts '----------------------------------------------'
    puts "register_error :#{name}, type: #{type}, code: '#{code}'"
    puts '----------------------------------------------'
  end
end