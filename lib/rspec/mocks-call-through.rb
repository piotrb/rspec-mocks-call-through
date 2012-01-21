module RSpec
  module Mocks

    module Methods
      def stub(sym_or_hash, opts={}, &block)
        if Hash === sym_or_hash
          sym_or_hash.each {|method, value| live_stub(method).and_return value }
        else
          __mock_proxy.add_live_stub(caller(1)[0], sym_or_hash.to_sym, opts, &block)
        end
      end
      alias :stub! :stub
    end

    class Proxy
      def add_live_stub(location, method_name, opts={}, &implementation)
        method_double[method_name].add_live_stub @error_generator, @expectation_ordering, location, opts, &implementation
      end
    end

    class MethodDouble
      attr_reader :object
      def add_live_stub(error_generator, expectation_ordering, expected_from, opts={}, &implementation)
        configure_method
        stub = LiveMessageExpectation.new(self, error_generator, expectation_ordering, expected_from, @method_name, nil, :any, opts, &implementation)
        stubs.unshift stub
        stub
      end
    end

    class LiveMessageExpectation < MessageExpectation

      attr_reader :method_double

      def initialize(method_double, *args, &block)
        @method_double = method_double
        super(*args, &block)
      end

      def invoke_return_block(*args, &block)
        block.taint if block
        super(*args, &block)
      end

      def and_call_through
        and_return { |*args|
          method_name = @method_double.obfuscate(@method_double.method_name)
          object = @method_double.object

          method = object.method(method_name)

          block = args.pop if args.last.kind_of?(Proc) && args.last.tainted?

          object.send(method_name, *args, &block)
        }
      end

    end

  end
end