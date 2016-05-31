require 'spec_helper'

describe "KNURLD API" do
  before(:all) do
    @consumer = Knurld::Consumer.new({:gender => "male", :username => ('a'..'z').to_a.shuffle[0,8].join, :password => "TESTUSER"})
    @appmodel = Knurld::AppModel.new({:vocabulary => ["Boston", "Ivory", "Sweden"]})
    @enrollment = Knurld::Enrollment.new({:consumer => @consumer, :appmodel => @appmodel})
    @phrase = @enrollment.status["phrase"]
    @repeats = @enrollment.status["repeats"]
    @enrollmentPhrase = []
    #from the phrase and number of repeats, construct our array (e.g. Boston, Boston, Boston, Ivory, Ivory, Ivory, Sweden, Sweden, Sweden)
    @phrase.each do |word|
      for i in 1..@repeats
        @enrollmentPhrase << word
      end
    end

    @analysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/ii4qa4vi8r3p4nt/6386420494.wav?dl=0", :num_words => @enrollmentPhrase.length})
    @intervals = []

    #create pairing of phrase to intervals, e.g. {"phrase":"boston", "begin":172, "end":839}
    @analysis.results["intervals"].each_with_index do |interval, index|
      interval['phrase'] = @enrollmentPhrase[index]
      @intervals << interval
    end
    @enrollment.populate("https://dl.dropboxusercontent.com/s/ii4qa4vi8r3p4nt/6386420494.wav?dl=0", @intervals)
  end

  it 'authenticates ian' do
    sleep 5 #let the enrollment populate
    @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/tgm52upwbymzgfc/bostonivorysweden.wav?dl=0", :num_words => 3})
    @verificationIntervals = []
    @verificationPhrase = ["Boston", "Ivory", "Sweden"]

    @verificationAnalysis.results["intervals"].each_with_index do |interval, index|
      interval['phrase'] = @verificationPhrase[index]
      @verificationIntervals << interval
    end

    @verification = Knurld::Verification.new({:appmodel => @appmodel, :consumer => @consumer})
    while @verification.status["phrases"] != ["Boston", "Ivory", "Sweden"]
      @verification = Knurld::Verification.new({:appmodel => @appmodel, :consumer => @consumer})
    end
    @verification.verify("https://dl.dropboxusercontent.com/s/tgm52upwbymzgfc/bostonivorysweden.wav?dl=0", @verificationIntervals)
    expect(@verification.status).to eq(true)

  end
end
