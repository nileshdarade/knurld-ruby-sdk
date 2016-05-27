#The verification process allows developers to verify a consumer's utterance
#of a word or phrase with that of a previously enrolled voiceprint.

#Read more here: https://developer.knurld.io/knurld-verification-apis/apis
module Knurld
  class Verification
    @href
    @id
    attr_accessor :consumer, :appmodel, :href, :id

    ##
    # Creates a new verification by associating a consumer with an appmodel.
    #
    # @param consumer [Consumer] The consumer to be verified
    # @param appmodel [AppModel] The appmodel to associated
    #
    # @return the verification instance
    def initialize(params={})
      begin
        consumer = params.fetch("consumer")
        appmodel = paras.fetch("appmodel")
      rescue => e
        $stderr.puts e.message
        raise "Consumer and Appmodel required!"
      end

      unless consumer.is_a?(Knurld::Consumer) && appmodel.is_a?(Knurld::AppModel)
        raise "Refusing to create verification. Consumer must be a Consumer instance, and AppModel must be an Appmodel instance."
      end

      @href = execute_request(:post, "verifications", {:consumer => consumer.href, :application => appmodel.href})["href"]
      @id = @href.split("/verifications/")[1]

      return self
    end

    ##
    # Performs a voice verification.
    # NOTE: This SDK does NOT support direct file uploads, as this is not considered best practice. Provide a dropbox or s3 link.
    # NOTE: Knurld (as well as this SDK) provides an "analysis" API that performs VAD analysis on wav files to find endpoints.
    # NOTE: Repeated enrollments are additive. They will strengthen a consumers vocal fingerprint, or add vocabulary.
    #
    # @param file_url [String] A link to a .wav file hosted on dropbox or s3
    # @param intervals [Array of Hashes] A list of word intervals. Each dictionary requires the following keys - “phrase”, “start”, and “stop”. Phrase is one of the vocabulary phrases defined in the associated app-model. Start and Stop represent the millisecond-based starting and ending points of each phrase. Eg, {“phrase”: “Chicago”, “start”: 0, “stop”: 1500}
    #
    # @return The enrollment URL, or raises
    def verify(file_url, intervals=nil)
      unless file_url.is_a?(String) && intervals.is_a?(Array) && intervals.first.is_a?(Hash)
        raise "Refusing to verify voice. File URL must be a string, and intervals must be an array of hashes."
      end
      execute_request(:post, "verifications/"+self.id, {"enrollment.wav" => file_url, :intervals => intervals})
    end
  end

  ##
  # Retrieves the status of a verification.
  #
  # @return true if the verification is completed, false if failed, or the full status otherwise
  def self.success_or_status
     response = execute_request(:get, "verifications/"+self.id)
     case response["status"]
       when "Completed"
         return response["verified"]
       when "Failed"
         false
       else
         response["status"]
     end
  end
end
