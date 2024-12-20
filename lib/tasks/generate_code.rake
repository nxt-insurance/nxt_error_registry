namespace :nxt_error_registry do
  desc 'Generate a unique error code'
  task :generate_code, %i[name type] => [:environment] do |_, args|
    Zeitwerk::Loader.eager_load_all
    name = args.fetch(:name, 'ErrorName').camelcase
    type = args.fetch(:type, 'ParentClass').camelcase

    harness = NxtErrorRegistry::CodesHarness.instance
    code = harness.generate_code
    puts '----------------------------------------------'
    puts "register_error :#{name}, type: #{type}, code: '#{code}'"
    puts '----------------------------------------------'
  end
end
