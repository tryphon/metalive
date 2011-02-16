require 'spec_helper'

describe Metalive::Shoutcast do

  it "should use given options as attributes" do
    Metalive::Shoutcast.new(:server => "dummy").server.should == "dummy"
  end

  context "by default" do

    subject { Metalive::Shoutcast.new }

    its(:port) { should == 8000 }

  end

  subject {   
    Metalive::Shoutcast.new :server => "dummy", :port => 8000, :password => "secret"
  }

  describe "base_uri" do
    
    it "should http url with server and port" do
      subject.server, subject.port = "dummy", 9000
      subject.base_uri.should == "http://dummy:9000"
    end

  end

  its(:path) { should == "/admin.cgi" }

  describe "query" do

    let(:song) { "Test Song" }
    
    it "should include password" do
      subject.password = "dummy"
      subject.query(song).should include(:pass => "dummy")
    end

    it "should include mode 'updinfo'" do
      subject.query(song).should include(:mode => "updinfo")
    end

    it "should include song paramater" do
      subject.query("dummy").should include(:song => "dummy")
    end

  end

  describe "headers" do
    
    it "should use user-agent 'ShoutcastDSP (Mozilla Compatible)'" do
      subject.headers["User-Agent"].should == 'ShoutcastDSP (Mozilla Compatible)'
    end

  end

  describe "update request" do

    subject {
      Metalive::Shoutcast.new :server => "server", :port => 9000, :password => "password"
    }

    def self.expected_uri
      "http://server:9000/admin.cgi?pass=password&mode=updinfo&song=Test"
    end
    def expected_uri
      self.class.expected_uri
    end

    before(:each) do
      FakeWeb.allow_net_connect = false
    end

    it "should be like #{expected_uri}" do
      FakeWeb.register_uri(:get, expected_uri, :body => "")
      subject.update("Test")
    end
    
  end

  describe "update" do

    before(:each) do
      subject.class.stub :get => true      
    end

    let(:song) { "Test" }
    
    it "should given string as song" do
      subject.should_receive(:query).with(song)
      subject.update(song)
    end

    it "should use :song attribute" do
      subject.should_receive(:query).with(song)
      subject.update(:song => song)
    end

    it "should return false when get request fails" do
      subject.class.stub(:get).and_raise("Error")
      subject.update(song).should be_false
    end
    
  end

end
