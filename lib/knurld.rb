require "knurld/version"
require "knurld/utils"
require "knurld/analysis"
require "knurld/appmodel"
require "knurld/consumer"
require "knurld/enrollment"
require "knurld/verification"

require "json"
require "rest-client"

module Knurld
  @developer_id
  @api_base_url = "https://api.knurld.io/"
  @client_id
  @client_secret
  @access_token

  class << self
    attr_accessor :developer_id, :client_id, :client_secret
  end

  #retrieves the status of the Knurld API
  def self.api_status
    response = self.execute_request(:get, "v1/status")
    if response.nil? do
      false
    else
      true
    end
  end

  #Our request handler. It is a helper method built on top of RestClient.
  #
  #@param method [Symbol] the HTTP method to be used. Accepts put, post, get, update, delete
  #@param endpoint [Symbol] the target URL endpoint, to be concatenated with api_base_url
  #@param data [Hash, String, Int] the payload to be placed in the request. By default, will be parsed with JSON
  #
  #@return the body of the response, or the appropriate error

  def self.execute_request(method, endpoint, data)
    url = self.api_base_url + endpoint

    #ensure
    begin
      data = data.to_json
    rescue
      $stderr.puts "Could not parse #{data}." + $!
      raise
    end

    response = RestClient::Request(method: :method, url: :url, headers: {params: data, self.headers})


    unless [:put, :delete, :post, :get, :update].include? method.downcase do
      $stderr.puts "Error. Method not allowed. Attempted: #{method}"
      raise
    end


    case response.code
      when 200, 201
        #success
        body
      when 400
        #bad request
        $stderr.puts "Error, Bad Request. \n The Request: #{response.request}. \n The Response: #{body}"
        nil
      when 401
        #auth error
        $stderr.puts "401 Unauthorized. \n The Request: #{response.request}. \n The Response: #{body}"
        nil
      when 403
        #forbidden
        $stderr.puts "403 Forbidden. \n The Request: #{response.request}. \n The Response: #{body}"
        nil
      when 404
        #not found
        $stderr.puts "404 Not Found. \n The Request: #{response.request}. \n The Response: #{body}"
        nil
      when 500
        #internal server error
        $stderr.puts "500 Internal Server Error. \n The Request: #{response.request}. \n The Response: #{body}"
        nil
      when 503
        #service unavailable
        $stderr.puts "503 Service unavailable. \n The Request: #{response.request}. \n The Response: #{body}"
        nil
    end
  end

  #Requests a new OAuth token using the provided client id and secret and returns appropriate headers.
  #@return [JSON] A JSON parsed authorization header as specified in the Knurld documentation.

  def self.headers
    if self.client_id.nil? || self.client_secret.nil? || self.developer_id.nil? do
      $stderr.puts "You MUST set client_id, client_secret, and developer_id before using Knurld services!"
      nil
    end

    response = self.execute_request(:post,
                    "oauth/client_credential/accesstoken?grant_type=client_credentials",
                    {:client_id => self.client_id, :client_secret => self.client_secret})

    unless response.nil? do
      self.access_token = response.access_token
      {"Authorization: Bearer"=>self.access_token, "Developer-Id: Bearer:"=>self.developer_id, "Content-Type"=>:json}.to_json
    end
  end
end
