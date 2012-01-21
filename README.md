# RSpec Mocks Call-Through

Adds call-through support for rspec stubs

## Method Stubs with call-through

    o.stub!(:foo).and_call_through

    o.foo then does all the standard stub stuff, and also calls the original method

## Also see

* [http://github.com/rspec/rspec-mocks](http://github.com/rspec/rspec-mocks)
