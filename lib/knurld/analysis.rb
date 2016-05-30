#The analysis API analyzes an audio wavefile to automatically
#find speech endpoints for the purpose of enrollment or verification.

#Read more here: https://developer.knurld.io/knurld-analysis-api/apis
module Knurld
  class Analysis
    attr_accessor :taskName, :taskStatus, :audioUrl, :num_words
    ##
    #Creates a new analysis request and ships it.
    #
    #@param audioUrl [String] The Dropbox or S3 (or otherwise) hosted .wav file URL
    #@param num_words [FixNum] The number of words contained in the .wav
    #
    #@return taskName [String] The ID of the analysis
    def initialize(params = {})
      begin
        @audioUrl = params.fetch(:audioUrl)
        @num_words = params.fetch(:num_words)
      rescue => e
        raise KeyError, "Refusing to begin analysis. Requires both audioUrl and num_words"
      end

      unless @audioUrl.is_a?(String) && @num_words.is_a?(Fixnum)
        raise TypeError, "Refusing analysis. audioUrl must be a string, and num_words must be a FixNum."
      end

      response = Knurld::execute_request(:post, "endpointAnalysis",
                                        {:audioUrl => @audioUrl, :num_words => @num_words})
      @taskName = response["taskName"]
      @taskStatus = response["taskStatus"]
      return @taskName
    end

    ##
    #Retrieves the results of an analysis.
    #
    #@return An Array of intervals if taskStatus is complete, or simply taskStatus
    def results
      return Knurld::execute_request(:get, "endpointAnalysis/"+@taskName)
      # if response["taskStatus"] == "completed"
      #   return response["intervals"]
      # else
      #   return response["taskStatus"]
      # end
    end
  end
end
