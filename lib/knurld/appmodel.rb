# App Models allow developers to create custom enrollment and verification schemes
# to fit their needs. They store configuration options and engine settings.
# For instance, one subset of consumers might be enrolled in a fixed phrase
# application e.g., my voice is my password with a high verification threshold.
# A different subset of consumers might be enrolled in a random phrase application
# with city names e.g., Boston, Chicago, Memphis, Atlanta. The Enrollments and
# Verifications endpoints will respond accordingly and prompt for information
# depending on the selected application.

#Read more here: https://developer.knurld.io/knurld-application-model-api/apis
class AppModel
end
