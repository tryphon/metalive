require 'httparty'

class Metalive::Icecast 
  include HTTParty

  attr_accessor :server, :port, :mount, :username, :password

  def initialize(options = {})
    options = { :username => "source", :port => 8000 }.update(options)
    options.each_pair { |k,v| send("#{k}=", v) }
  end

  def authentication
    { :username => username, :password => password }
  end

  def query(song)
    { :mount => mount, :mode => "updinfo", :song => song }
  end

  def mount
    @mount.start_with?("/") ? @mount : "/#{@mount}"
  end

  def base_uri
    "http://#{server}:#{port}"
  end

  def path
    "/admin/metadata"
  end

  def update(metadata)
    song = (Hash === metadata ? metadata[:song] : metadata.to_s)
    self.class.get path, :base_uri => base_uri, :basic_auth => authentication, :query => query(song)
    true
  rescue => e
    false
  end
end
