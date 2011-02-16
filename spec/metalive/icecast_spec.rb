require 'spec_helper'

describe Metalive::Icecast do

  it "should use given options as attributes" do
    Metalive::Icecast.new(:server => "dummy").server.should == "dummy"
  end

  context "by default" do

    subject { Metalive::Icecast.new }

    its(:port) { should == 8000 }
    its(:username) { should == "source" }

  end

  subject {   
    Metalive::Icecast.new :server => "dummy", :port => 8000, :password => "secret", :mount => "/test.ogg"
  }

  describe "base_uri" do
    
    it "should http url with server and port" do
      subject.server, subject.port = "dummy", 9000
      subject.base_uri.should == "http://dummy:9000"
    end

  end

  its(:path) { should == "/admin/metadata" }

  describe "mount" do
    
    it "should be prefixed with / if missing" do
      subject.mount = "test.ogg"
      subject.mount.should == "/test.ogg"
    end

  end

  describe "authentication" do
    
    it "should use username and password" do
      subject.username, subject.password = "username", "password"
      subject.authentication.should == { :username => "username", :password => "password" }
    end

  end

  describe "query" do

    let(:song) { "Test Song" }
    
    it "should include mount" do
      subject.mount = "/test.ogg"
      subject.query(song).should include(:mount => "/test.ogg")
    end

    it "should include mode 'updinfo'" do
      subject.query(song).should include(:mode => "updinfo")
    end

    it "should include song paramater" do
      subject.query("dummy").should include(:song => "dummy")
    end

  end

  describe "update request" do

    subject {
      Metalive::Icecast.new :server => "server", :port => 9000, :password => "password", :mount => "/test.ogg"
    }

    let(:success_body) { "<?xml version=\"1.0\"?>\n<iceresponse><message>Metadata update successful</message><return>1</return></iceresponse>" }

    def self.expected_uri
      "http://source:password@server:9000/admin/metadata?mount=%2Ftest.ogg&mode=updinfo&song=Test"
    end

    def expected_uri
      self.class.expected_uri
    end

    before(:each) do
      FakeWeb.allow_net_connect = false
    end

    it "should be like #{expected_uri}" do
      FakeWeb.register_uri(:get, expected_uri, :body => success_body)
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
