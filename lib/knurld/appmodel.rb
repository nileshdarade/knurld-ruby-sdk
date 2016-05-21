# # App Models allow developers to create custom enrollment and verification schemes
# # to fit their needs. They store configuration options and engine settings.
# # For instance, one subset of consumers might be enrolled in a fixed phrase
# # application e.g., my voice is my password with a high verification threshold.
# # A different subset of consumers might be enrolled in a random phrase application
# # with city names e.g., Boston, Chicago, Memphis, Atlanta. The Enrollments and
# # Verifications endpoints will respond accordingly and prompt for information
# # depending on the selected application.
#
# #Read more here: https://developer.knurld.io/knurld-application-model-api/apis
# module Knurld
#     class AppModel
#       include Knurld::APIOperations
#       attr_accessor :enrollmentRepeats, :vocabulary, :verificationLength,
#                     :threshold, :autoThresholdEnable, :autoThresholdMaxRise,
#                     :autoThresholdClearance, :useModelUpdate, :modelUpdateDailyLimit
#       ##
#       # Creates an appmodel instance.
#       # @param enrollmentRepeats [Int] # of times the user is asked to repeat each phrase during the enrollment process. Minimum required is 3.
#       # @param vocabulary [Array of Strings] Consumers may enroll with any combination of the phrases associated with app-model. A subset of phrases will be selected for each verification.
#       # @param verificationLength [Int] 	# of phrases to use for verification. Recommended minimum is 3. Make sure that this is equal to or less than the number of phrases specified in the vocabulary parameter. The actual phrases asked for by the engine at verification time is a random subset of the phrase vocabulary.
#       # @param threshold (Optional) [Float] 	Optional. Score threshold for verification.
#       # @param autoThresholdEnable (Optional) [Boolean] If enabled, consumers who constantly score high will have their threshold adjusted automatically.
#       # @param autoThresholdClearance (Optional) [Int] Distance above the base threshold that a consumer’s score needs to be to activate auto-adjustment.
#       # @param autoThresholdMaxRise (Optional) [Int] Maximum value above the base threshold that a consumer’s auto-adjustment will rise to.
#       # @param useModelUpdate (Optional) [Boolean] Enable augmenting enrollment data with audio from successful verifications.
#       # @param modelUpdateDailyLimit (Optional) [Int] Maximum amount of times per day that model updating will be applied
#       #
#       # @return Instance of AppModel
#       def initialize(enrollmentRepeats=3, vocabulary=@VOCABULARY, verificationLength=3,
#                 threshold=2.0, autoThresholdEnable=true, autoThresholdClearance=2.5,
#                 autoThresholdMaxRise=1.0, useModelUpdate=false, modelUpdateDailyLimit=1)
#
#           #type check
#           unless @enrollmentRepeats.is_a? Fixnum and
#             @vocabulary.is_a? Array and
#             @verificationlength.is_a? Fixnum and
#             @threshold.is_a? Float and
#             @autoThresholdEnable.is_a? Boolean and
#             @autoThresholdClearance.is_a? Int and
#             @autoThresholdMaxRise.is_a? Int and
#             @useModelUpdate.is_a? Boolean and
#             @modelUpdateDailyLimit.is_a? Int
#
#             raise "Refusing to create Appmodel. Incorrect argument type. Please refer to documentation and ensure typing."
#           end
#
#           @enrollmentRepeats = enrollmentRepeats
#           @vocabulary = vocabulary
#           @verificationLength = verificationLength
#           @threshold = threshold
#           @autoThresholdEnable = autoThresholdEnable
#           @autoThresholdClearance = autoThresholdClearance
#           @autoThresholdMaxRise = autoThresholdMaxRise
#           @useModelUpdate = useModelUpdate
#           @modelUpdateDailyLimit = modelUpdateDailyLimit
#
#
#       end
#
#
#     end
#   end
# end
