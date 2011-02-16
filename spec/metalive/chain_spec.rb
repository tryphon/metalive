require 'spec_helper'

class Metalive::Test

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def update(metadata)
    options[:result] or true
  end

end

describe Metalive::Chain do

  let(:updater) { Metalive::Test.new }
  let(:options) { {:dummy => true} }

  describe "add" do
    
    it "should add a given updater" do
      subject.add(updater)
      subject.updaters.should include(updater)
    end

    it "should create a updater with specified class and options" do
      subject.should_receive(:create).with("dummy", options).and_return(updater)
      subject.add("dummy", options)
      subject.updaters.should include(updater)
    end

  end

  describe "create" do
    
    it "should find Metalive class with a given String or Symbol" do
      subject.create(:test).should be_instance_of(Metalive::Test)
    end

    it "should use given class to create updater" do
      subject.create(Metalive::Test).should be_instance_of(Metalive::Test)
    end

    it "should use given options to create updater" do
      subject.create(:test, options).options.should == options
    end

  end

  it "should use missing method name as updater name" do
    subject.should_receive(:add).with(:test, options)
    subject.test options
  end

  describe "update" do

    let(:metadata) { "metadata" }
    
    it "should be true without updaters" do
      subject.update(metadata).should be_true
    end

    it "should be true when all updates are successfull" do
      subject.add(:test).add(:test).update(metadata).should be_true
    end

    it "should be false when on of the updates is failed" do
      subject.add(:test, :result => false).add(:test).update(metadata).should be_true
    end

  end

end
