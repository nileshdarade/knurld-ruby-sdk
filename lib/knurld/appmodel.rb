# App Models allow developers to create custom enrollment and verification schemes
# to fit their needs. They store configuration options and engine settings.
# For instance, one subset of consumers might be enrolled in a fixed phrase
# application e.g., my voice is my password with a high verification threshold.
# A different subset of consumers might be enrolled in a random phrase application
# with city names e.g., Boston, Chicago, Memphis, Atlanta. The Enrollments and
# Verifications endpoints will respond accordingly and prompt for information
# depending on the selected application.

#Read more here: https://developer.knurld.io/knurld-application-model-api/apis
module Knurld
  class AppModel
    attr_accessor :enrollmentRepeats, :vocabulary, :verificationLength,
                  :threshold, :autoThresholdEnable, :autoThresholdMaxRise,
                  :autoThresholdClearance, :useModelUpdate, :modelUpdateDailyLimit
    ##
    # Creates an appmodel instance.
    # @param enrollmentRepeats [Int] # of times the user is asked to repeat each phrase during the enrollment process. Minimum & default is 3.
    # @param vocabulary [Array of Strings] Consumers may enroll with any combination of the phrases associated with app-model. A subset of phrases will be selected for each verification.
    # @param verificationLength [Int] # of phrases to use for verification. Recommended minimum & default is 3. Make sure that this is equal to or less than the number of phrases specified in the vocabulary parameter. The actual phrases asked for by the engine at verification time is a random subset of the phrase vocabulary.
    # @param threshold (Optional) [Float] 	Optional. Score threshold for verification.
    # @param autoThresholdEnable (Optional) [Boolean] If enabled, consumers who constantly score high will have their threshold adjusted automatically.
    # @param autoThresholdClearance (Optional) [Float] Distance above the base threshold that a consumer’s score needs to be to activate auto-adjustment.
    # @param autoThresholdMaxRise (Optional) [Int] Maximum value above the base threshold that a consumer’s auto-adjustment will rise to.
    # @param useModelUpdate (Optional) [Boolean] Enable augmenting enrollment data with audio from successful verifications.
    # @param modelUpdateDailyLimit (Optional) [Int] Maximum amount of times per day that model updating will be applied
    #
    # @return Instance of AppModel
    def initialize(params={})
        #the approve list of vocabulary for use with the Knurld Voice API
        @VOCABULARY = %w(Atlanta Athens England Olive Octagon Baltimore
                        London Brazil Amber Diamond Boston Paris Mexico
                        Orange Arrow Chicago Toronto Japan Yellow Triangle
                        Cleveland Berlin Germany Purple Circle Dallas Madrid
                        Turkey Maroon Pyramid Denver Canada Ivory Oval
                        Memphis Sweden Crimson Cylinder Nashville Orlando
                        Phoenix Seattle)

        #set our instance variables,
        #setting defaults if any are nil.
        @enrollmentRepeats = params.fetch(:enrollmentRepeats, 3)
        @vocabulary = params.fetch(:vocabulary, @VOCABULARY)
        @verificationLength = params.fetch(:verificationLength, 3)
        @threshold = params.fetch(:threshold, 2.0)
        @autoThresholdEnable = params.fetch(:autoThresholdEnable, true)
        @autoThresholdClearance = params.fetch(:autoThresholdClearance, 2.5)
        @autoThresholdMaxRise = params.fetch(:autoThresholdMaxRise, 1)
        @useModelUpdate = params.fetch(:useModelUpdate, false)
        @modelUpdateDailyLimit = params.fetch(:modelUpdateDailyLimit, 1)

        def self.to_json
          return {
            :enrollmentRepeats => @enrollmentRepeats,
            :vocabulary => @VOCABULARY,
            :verificationLength => @verificationLength,
            :threshold => @threshold,
            :autoThresholdEnable => @autoThresholdEnable,
            :autoThresholdClearance => @autoThresholdClearance,
            :autoThresholdMaxRise => @autoThresholdMaxRise,
            :useModelUpdate => @useModelUpdate,
            :modelUpdateDailyLimit => @modelUpdateDailyLimit
          }
        end

        #type check
        unless @enrollmentRepeats.is_a? Fixnum and
          @vocabulary.is_a? Array and
          @verificationLength.is_a? Fixnum and
          @threshold.is_a? Float and
          !!@autoThresholdEnable == @autoThresholdEnable and
          @autoThresholdClearance.is_a? Float and
          @autoThresholdMaxRise.is_a? Fixnum and
          !!@useModelUpdate == @useModelUpdate and
          @modelUpdateDailyLimit.is_a? Fixnum

          raise "Refusing to create Appmodel. Incorrect argument type.
          Please refer to documentation and ensure typing."
        end

        #send our request off to Knurld
        @href = Knurld::execute_request(:post, "app-models", self.to_json)["href"]
        @id = @href.split('/app-models/')[1] #grab the part of the href after /app-models/
    end
  end
end
