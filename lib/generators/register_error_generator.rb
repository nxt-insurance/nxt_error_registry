class RegisterErrorGenerator < Rails::Generators::Base
  desc "This generator creates a register_error statement to include in your code"
  class_option :name, type: :string, default: 'ErrorName'
  class_option :type, type: :string, default: 'ParentClass'

  def register_error
    Zeitwerk::Loader.eager_load_all
    name = options['name'].camelcase
    type = options['type'].camelcase
    harness = NxtErrorRegistry::CodesHarness.instance
    code = harness.generate_code
    puts '----------------------------------------------'
    puts "register_error :#{name}, type: #{type}, code: '#{code}'"
    puts '----------------------------------------------'
  end
end
