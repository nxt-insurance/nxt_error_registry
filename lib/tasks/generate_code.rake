namespace :nxt_error_registry do
  desc 'Generate a unique error code'
  task :generate_code, [:name, :type] => [:environment] do |_, args|
    Rails.application.eager_load!
    name = args.fetch(:name, 'ErrorName').camelcase
    type = args.fetch(:type, 'ParentClass').camelcase

    harness = NxtErrorRegistry::CodeGenerators::Default.instance
    code = harness.generate_code
    puts '----------------------------------------------'
    puts "register_error :#{name}, type: #{type}, code: '#{code}'"
    puts '----------------------------------------------'
  end
end

