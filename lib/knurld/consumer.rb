# This file stores and controls all interaction with Knurld Voice API Consumers.
# It, via the AppModel object, stores ID information about itself and is object of
# enrollments & verifications.

# Read more here: https://developer.knurld.io/knurld-consumer-apis/apis
module Knurld
  class Consumer
    @gender
    @username
    @password
    @href
    @id
    attr_accessor :gender, :username, :password, :appmodel, :id, :href

    ##
    # Creates our consumer.
    #
    # @param gender [String] "Male", "Female", "M", or "F".
    # @param username [String] The username of the consumer.
    # @param password [String] The password, for later use.
    #
    # @return The Consumer instance.
    def initialize(params={})
      if params.has_key?("href")
        # the user being created is being created from a knurld response object,
        # i.e. they already existed. therefore, there will be no password.
        @href = params.fetch("href")
        @gender = params.fetch("gender")
        @username = params.fetch("username")
        @id = @href.split("/consumers/")[1]
        return self
      end
      #href was blank, so it must be an entirely new consumer.
      begin
        @gender = params.fetch(:gender)
        @username = params.fetch(:username)
        @password = params.fetch(:password)
      rescue => err
        raise KeyError, "Refusing to create Consumer. Gender, Username, and Password are required."
      end

      case @gender
      when "male"
        self.gender = "M"
      when "female"
        self.gender = "F"
      else
        begin
          unless gender.upcase == "M" || gender.upcase == "F"
            raise TypeError, "Gender must be 'male', 'female', 'm', or 'f'"
          else
            self.gender = gender.upcase
          end
        rescue => e
          raise TypeError, "Error processing gender."
        end
      end

      if username.is_a?(String)
        self.username = username
      else
        raise TypeError, "Consumer username can only be a string."
      end

      if password.is_a?(String)
        self.password = password
      else
        raise TypeError, "Consumer password can only be a string."
      end

      #if our consumer is being created from a preexisting knurld object,
      #dont' create it again!
      response = Knurld::execute_request(:post, "consumers",
                      {:gender => self.gender, :username => self.username,
                      :password => self.password})
      @href = response["href"]
      @id = @href.split("/consumers/")[1]
    end

    ##
    # Changes the consumer's password.
    #
    # @param Password [String] The new password
    #
    # @return The server response
    def change_password(password)
      if password.is_a? String
        self.password = password
        Knurld::execute_request(:post, "consumers/"+@id, {:password => password})
      else
        raise TypeError, "New password must be a String"
      end
    end

    ##
    # Attempts authentication of a Consumer using username and password.
    #
    # @return token [String] The OAuth token upon succces, otherwise return false
    def authenticate
      begin
        return Knurld::execute_request(:post, "consumers/token", {:username => self.username, :password => self.password})["token"]
      rescue => e
        $stderr.puts e.message
        return false
      end
    end


    ##
    # Calls Knurld's Delete method on an app-model.
    #
    # @returns the deleted Consumer
    def destroy
      begin
        Knurld::execute_request(:delete, "consumers/"+self.id)
      rescue => e
        raise e
      end
    end
  end
end
