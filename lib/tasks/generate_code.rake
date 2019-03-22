namespace :nxt_error_registry do
  desc 'Generate a unique error code'
  task generate_code: :environment do
    Rails.application.eager_load!

    harness = NxtErrorRegistry::CodesHarness.instance
    code = harness.generate_code
    puts '----------------------------------------------'
    puts "register_error :ErrorName, code: '#{code}'"
    puts '----------------------------------------------'
  end
end

