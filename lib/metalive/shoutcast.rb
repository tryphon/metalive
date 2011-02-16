require 'httparty'

class Metalive::Shoutcast
  include HTTParty

  attr_accessor :server, :port, :password

  def initialize(options = {})
    options = { :port => 8000 }.update(options)
    options.each_pair { |k,v| send("#{k}=", v) }
  end

  def query(song)
    { :mode => "updinfo", :song => song, :pass => password }
  end

  def base_uri
    "http://#{server}:#{port}"
  end

  def path
    "/admin.cgi"
  end

  def headers
    { "User-Agent" => "ShoutcastDSP (Mozilla Compatible)" }
  end

  def update(metadata)
    song = (Hash === metadata ? metadata[:song] : metadata.to_s)
    self.class.get path, :base_uri => base_uri, :query => query(song), :headers => headers
    true
  rescue => e
    false
  end
end
