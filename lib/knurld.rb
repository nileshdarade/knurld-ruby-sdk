require_relative "knurld/version"
require_relative "knurld/utils"
require_relative "knurld/analysis"
require_relative "knurld/appmodel"
require_relative "knurld/consumer"
require_relative "knurld/enrollment"
require_relative "knurld/verification"

require "json"
require "rest-client"

module Knurld
  @developer_id
  @api_base_url = "https://api.knurld.io/v1/"
  @client_id
  @client_secret
  @access_token

  class << self
    attr_accessor :developer_id, :client_id, :client_secret, :api_base_url
  end

  #Retrieves the status of the Knurld API
  def self.api_status
    response = execute_request(:get, "status", nil, nil)
    if response.nil?
      false
    else
      true
    end
  end

  #Our request handler. It is a helper method built on top of RestClient.
  #
  #@param method [Symbol] the HTTP method to be used. Accepts put, post, get, update, delete
  #@param endpoint [Symbol] the target URL endpoint, to be concatenated with api_base_url
  #@param data [Hash, String, Int] the payload to be placed in the request. Assumed to already be json.
  #
  #@return the body of the response upon success, otherwise nil

  def self.execute_request(method, endpoint, data=nil, headers=nil)
    #construct our url
    #we have to drop "v1/" from the API url if we're authenticating
    unless endpoint.include? "oauth"
      url = @api_base_url + endpoint
    else
      url = @api_base_url.slice(0, @api_base_url.length - 3) + endpoint
    end

    if headers == nil || !headers.include?("Content-Type")
      begin
        data = data.to_json
      rescue => e
        raise "Could not parse data! Attempted: #{data}"
      end
    end

    #ensure method is allowed
    unless [:put, :delete, :post, :get, :update].include? method.downcase
      $stderr.puts "Error. Method not allowed. Attempted: #{method}"
      raise
    end


    #perform the request
    begin
      if headers == nil
        headers = make_headers
      end
      #RestClient has a strict no payload parameter rule for get requests.
      response = RestClient::Request.execute(method: method, url: url, payload: data, headers: headers)
    rescue RestClient::Exception => e
      raise "Error emitting request. Error: #{e.message}. Response: #{e.response}."
    end

    begin
      return JSON.parse(response.body)
    rescue => e
      return nil
    end
  end

  #Requests a new OAuth token using the provided client id and secret and returns appropriate headers.
  #@return [Hash] An authorization header as specified in the Knurld documentation.
  def self.make_headers
    if Knurld.client_id.nil?
      raise "You MUST set your client_id!"
    elsif Knurld.client_secret.nil?
      raise "You MUST set your client_secret!"
    elsif Knurld.developer_id.nil?
      raise "You MUST set your developer_id!"
    end

    response = self.execute_request(:post,
                    "oauth/client_credential/accesstoken?grant_type=client_credentials",
                    {:client_id => @client_id, :client_secret => @client_secret}, {"Content-Type" => "application/x-www-form-urlencoded"})

    unless response.nil?
      @access_token = response["access_token"]

      return {:Authorization => "Bearer "+@access_token,
        :'Developer-Id' => "Bearer: "+@developer_id,
        :Content_Type => "application/json"}
    end
  end

  #Retrieve all app models for the authenticated user.
  #@return [Array] All app Models
  def self.retrieve_app_models
    results = []
    self.execute_request(:get, "app-models")["items"].each do |model|
      results << Knurld::AppModel.new(model)
    end
    results
  end

  #Retrieve a specific app model.
  #@param id [String] the id or url of the desired app model
  #
  #@return [AppModel] The specific app model
  def self.retrieve_app_model(id)
    if id.contains? "api.knurld.io" # it is a URL, not just an id
      id = id.split("/app-models/")[1]
    end
    Knurld::AppModel.new(self.execute_request(:get, "app-models/"+id))
  end

  #Retrieve a specific consumer.
  #@param id [String] the id or url of the desired consumer
  #
  #@return [Consumer] The specific consumer
  def self.retrieve_consumer(id)
    if id.contains? "api.knurld.io" # it is a URL, not just an id
      id = id.split("/consumers/")[1]
    end
    Knurld::Consumer.new(self.execute_request(:get, "consumers/"+id))
  end

  #Retrieve all consumers for a developer.
  #@return [Array of Consumers]
  def self.retrieve_consumers
    results = []
    self.execute_request(:get, "consumers")["items"].each do |consumer|
      results << Knurld::Consumer.new(consumer)
    end
  end

  ##
  #Retrieves all enrollments for all appmodels.
  #
  # @return Array of enrollments
  def self.retrieve_enrollments
    results = []
    self.execute_request(:get, "enrollments")["items"].each do |enrollment|
      consumer = self.retrieve_consumer(enrollment["consumer"]["href"])
      appmodel = self.retrieve_app_model(enrollment["application"]["href"])
      results << Knurld::Enrollment.new({:consumer => consumer, :appmodel => appmodel})
    end
end
