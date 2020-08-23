[![CircleCI](https://circleci.com/gh/nxt-insurance/nxt_error_registry.svg?style=svg)](https://circleci.com/gh/nxt-insurance/nxt_error_registry)

# NxtErrorRegistry

Register all your errors in a sane way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nxt_error_registry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nxt_error_registry

## Usage

```ruby
class LevelOne
  extend NxtErrorRegistry
  register_error :LevelOneError, type: StandardError, code: 'r0b.1b0'
  # This will set the LevelOne::LevelOneError constant that you can raise anywhere
  register_error :LevelTwoError, type: LevelOneError, code: 'ah6.1h1', capture: true, reraise: false
  # You can also pass in additional options when registering your errors. These will be available on you error class 
  
  def raise_level_one_error
    raise LevelOneError, 'There was an error on level'
  rescue LevelOneError => e
    puts e.code # would output '100.100'
  rescue LevelTwoError => e
    puts e.options # { capture: true, reraise: false } 
  end
end
```

`register_error` will make sure that the code was not already registered anywhere else in your app. 

### Generate an register_error statement to include in your code with the rails generator

All arguments are optional and will be set to a placeholder if not provided 

```ruby
rails g register_error --name NewErrorName --type SomeKindOfError 
# => register_error :NewErrorName, type: SomeKindOfError, code: '45h.74g'
``` 

### Or use the rake task instead. 

All arguments are optional and will be set to a placeholder if not provided

```ruby
rake nxt_error_registry:generate_code\[ErrorName,ParentType\] 
# => register_error :ErrorName, type: ParentType, code: 'r5h.h00'
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nxt-insurance/nxt_error_registry.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
