require 'spec_helper'

describe RSpec::Mocks do

  class Foo
    def self.status
      @status
    end
    def self.reset!
      @status = {}
    end
    def one
      self.class.status[:one] ||= []
      self.class.status[:one] << [[], nil]
    end
    def two(a,b,c)
      self.class.status[:two] ||= []
      self.class.status[:two] << [[a,b,c], nil]
    end
    def three(a,&block)
      self.class.status[:three] ||= []
      self.class.status[:three] << [[a],block]
    end
    def four(a,b)
      self.class.status[:four] ||= []
      self.class.status[:four] << [[a,b],nil]
    end
  end

  before do
    Foo.reset!
  end

  it "arity: 0" do
    o = Foo.new
    o.stub!(:one).and_call_through
    o.one
    Foo.status[:one].should == [
      [[], nil]
    ]
  end

  it "arity: 3" do
    o = Foo.new
    o.stub!(:two).and_call_through
    o.two(:a, 2, "c")
    Foo.status[:two].should == [
      [[:a, 2, "c"], nil]
    ]
  end

  it "arity: 1 + block" do
    o = Foo.new
    o.stub!(:three).and_call_through
    block = proc { "block" }
    o.three(:a, &block) 
    Foo.status[:three].should == [
      [[:a], block]
    ]
  end

  it "arity: 2, last param is a proc" do
    o = Foo.new
    o.stub!(:four).and_call_through
    block = proc { "block" }
    o.four(:a, block) 
    Foo.status[:four].should == [
      [[:a, block], nil]
    ]
  end

end