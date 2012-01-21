require 'rspec/core'
require 'rspec/mocks'
require 'rspec/expectations'
require 'rspec/mocks-call-through'

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
  config.include(RSpec::Mocks::Methods)

  config.filter_run_excluding :ruby => lambda {|version|
    case version.to_s
    when "!jruby"
      RUBY_ENGINE != "jruby"
    when /^> (.*)/
      !(RUBY_VERSION.to_s > $1)
    else
      !(RUBY_VERSION.to_s =~ /^#{version.to_s}/)
    end
  }
end
