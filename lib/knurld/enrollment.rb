# The enrollment process allow developers to associate a consumer with an
# application model. After enrollment is completed, the consumer will be able
# to verify their identity by speaking the phrase used during enrollment.

#Read more here: https://developer.knurld.io/knurld-enrollment-api/apis
module Knurld
  class Enrollment
    attr_accessor :id, :href, :consumer, :appmodel

    @href
    @id
    def initialize(params={})
      begin
        @consumer = params.fetch(:consumer)
        @appmodel = params.fetch(:appmodel)
      rescue => e
        $stderr.puts e.message
        raise KeyError, "Consumer and Appmodel required!"
      end

      unless consumer.is_a?(Knurld::Consumer) && appmodel.is_a?(Knurld::AppModel)
        raise TypeError, "Refusing to create enrollment. Consumer must be a Consumer instance, and AppModel must be an Appmodel instance."
      end

      @href = Knurld::execute_request(:post, "enrollments", {:consumer => @consumer.href, :application => @appmodel.href})["href"]
      @id = @href.split("/enrollments/")[1]

      return self
    end

    ##
    # Populates an enrollment.
    # NOTE: This SDK does NOT support direct file uploads, as this is not considered best practice. Provide a dropbox or s3 link.
    # NOTE: Knurld (as well as this SDK) provides an "analysis" API that performs VAD analysis on wav files to find endpoints.
    # NOTE: Repeated enrollments are additive. They will strengthen a consumers vocal fingerprint, or add vocabulary.
    #
    # @param file_url [String] A link to a .wav file hosted on dropbox or s3
    # @param intervals [Array of Hashes] A list of word intervals. Each dictionary requires the following keys - “phrase”, “start”, and “stop”. Phrase is one of the vocabulary phrases defined in the associated app-model. Start and Stop represent the millisecond-based starting and ending points of each phrase. Eg, {“phrase”: “Chicago”, “start”: 0, “stop”: 1500}
    #
    # @return The enrollment URL, or raises
    def populate(file_url, intervals=[])
      unless file_url.is_a?(String) &&
              intervals.is_a?(Array) &&
              intervals.first.is_a?(Hash)
        raise TypeError, "Refusing to populate enrollment. File URL must be a string, and intervals must be an array of hashes."
      end

      Knurld::execute_request(:post, "enrollments/"+self.id, {"enrollment.wav" => file_url, :intervals => intervals})
    end

    ##
    # Retrieves the status of an enrollment.
    #
    # @return true if te enrollment is completed, false if failed, or the full status otherwise
    def self.complete_or_status
       status = Knurld::execute_request(:get, "enrollments/"+self.id)["status"]
       case status
         when "Completed"
           true
         when "Failed"
           false
         else
           status
       end
    end

    ##
    # Requests deletion of an enrollment.
    def self.destroy
      Knurld::execute_request(:delete, "enrollments"/+self.id)
    end
  end
end
