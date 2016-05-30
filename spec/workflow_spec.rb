require 'spec_helper'

describe "KNURLD API" do
  # @delwinsEntries = %w(
  #
  # )
  before(:all) do
    @consumer = Knurld::Consumer.new({:gender => "male", :username => ('a'..'z').to_a.shuffle[0,8].join, :password => "TESTUSER"})
    @appmodel = Knurld::AppModel.new({:vocabulary => ["Boston", "Ivory", "Sweden"]})
    @enrollment = Knurld::Enrollment.new({:consumer => @consumer, :appmodel => @appmodel})
    @phrase = @enrollment.status["phrase"]
    @repeats = @enrollment.status["repeats"]
    @enrollmentPhrase = []
    @phrase.each do |word|
      for i in 1..@repeats
        @enrollmentPhrase << word
      end
    end

    @analysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/ii4qa4vi8r3p4nt/6386420494.wav?dl=0", :num_words => @enrollmentPhrase.length})
    @intervals = []
    @analysis.results["intervals"].each_with_index do |interval, index|
      interval['phrase'] = @enrollmentPhrase[index]
      @intervals << interval
    end
    @enrollment.populate("https://dl.dropboxusercontent.com/s/ii4qa4vi8r3p4nt/6386420494.wav?dl=0", @intervals)
  end

  it 'fails delwin' do
    sleep 5 #let the enrollment populate
    @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/xwnlsabj91w26b9/Audio%20Track-2.wav?dl=0", :num_words => 3})
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

    # puts @verificationIntervals
    @verification.verify("https://dl.dropboxusercontent.com/s/tgm52upwbymzgfc/bostonivorysweden.wav?dl=0", @verificationIntervals)
    puts @verification.status
    expect(@verification.status).to eq(false)
  end

  # it 'fails collin' do
  #   @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/jo1pu87fbk6qx9w/Audio%20Track-2.wav?dl=0", :num_words => 3})
  #   @verificationIntervals = []
  #   puts @verification.status
  #   @verificationAnalysis.results.each_with_index do |interval, index|
  #     interval['phrase'] = @phrase[index]
  #     @verificationIntervals << interval
  #   end
  #
  #   @payload = []
  #   @verification.status["phrases"].each do |word|
  #     @payload << @verificationIntervals.select {|key, val| key.value?(word)}[0]
  #   end
  #
  #   puts @payload
  #   @verification.verify("https://dl.dropboxusercontent.com/s/jo1pu87fbk6qx9w/Audio%20Track-2.wav?dl=0", @payload)
  #   puts @verification.status
  #   expect(@verification.status).to eq(false)
  # end
  #
  # it 'fails collin' do
  #   @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/f2ct3eh8kr0hoa0/Audio%20Track-3.wav?dl=0", :num_words => 3})
  #   @verificationIntervals = []
  #   puts @verification.status
  #   @verificationAnalysis.results.each_with_index do |interval, index|
  #     interval['phrase'] = @phrase[index]
  #     @verificationIntervals << interval
  #   end
  #
  #   @payload = []
  #   @verification.status["phrases"].each do |word|
  #     @payload << @verificationIntervals.select {|key, val| key.value?(word)}[0]
  #   end
  #
  #   puts @payload
  #   @verification.verify("https://dl.dropboxusercontent.com/s/f2ct3eh8kr0hoa0/Audio%20Track-3.wav?dl=0", @payload)
  #   puts @verification.status
  #   expect(@verification.status).to eq(false)
  # end
  #
  # it 'fails collin' do
  #   @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/uytzuf2tz6ok8uw/Audio%20Track-4.wav?dl=0", :num_words => 3})
  #   @verificationIntervals = []
  #   puts @verification.status
  #   @verificationAnalysis.results.each_with_index do |interval, index|
  #     interval['phrase'] = @phrase[index]
  #     @verificationIntervals << interval
  #   end
  #
  #   @payload = []
  #   @verification.status["phrases"].each do |word|
  #     @payload << @verificationIntervals.select {|key, val| key.value?(word)}[0]
  #   end
  #
  #   puts @payload
  #   @verification.verify("https://dl.dropboxusercontent.com/s/uytzuf2tz6ok8uw/Audio%20Track-4.wav?dl=0", @payload)
  #   puts @verification.status
  #   expect(@verification.status).to eq(false)
  # end
  #
  # it 'fails collin' do
  #   @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/q80cobypj6k0xqt/Audio%20Track-5.wav?dl=0", :num_words => 3})
  #   @verificationIntervals = []
  #   puts @verification.status
  #   @verificationAnalysis.results.each_with_index do |interval, index|
  #     interval['phrase'] = @phrase[index]
  #     @verificationIntervals << interval
  #   end
  #
  #   @payload = []
  #   @verification.status["phrases"].each do |word|
  #     @payload << @verificationIntervals.select {|key, val| key.value?(word)}[0]
  #   end
  #
  #   puts @payload
  #   @verification.verify("https://dl.dropboxusercontent.com/s/q80cobypj6k0xqt/Audio%20Track-5.wav?dl=0", @payload)
  #   puts @verification.status
  #   expect(@verification.status).to eq(false)
  # end
  #
  # it 'fails collin' do
  #   @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/12zgp9to7bnbtym/Audio%20Track-6.wav?dl=0", :num_words => 3})
  #   @verificationIntervals = []
  #   puts @verification.status
  #   @verificationAnalysis.results.each_with_index do |interval, index|
  #     interval['phrase'] = @phrase[index]
  #     @verificationIntervals << interval
  #   end
  #
  #   @payload = []
  #   @verification.status["phrases"].each do |word|
  #     @payload << @verificationIntervals.select {|key, val| key.value?(word)}[0]
  #   end
  #
  #   puts @payload
  #   @verification.verify("https://dl.dropboxusercontent.com/s/12zgp9to7bnbtym/Audio%20Track-6.wav?dl=0", @payload)
  #   puts @verification.status
  #   expect(@verification.status).to eq(false)
  # end
  #
  # it 'fails collin' do
  #   @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/9sjcew8ficzk8u6/Audio%20Track-7.wav?dl=0", :num_words => 3})
  #   @verificationIntervals = []
  #   puts @verification.status
  #   @verificationAnalysis.results.each_with_index do |interval, index|
  #     interval['phrase'] = @phrase[index]
  #     @verificationIntervals << interval
  #   end
  #
  #   @payload = []
  #   @verification.status["phrases"].each do |word|
  #     @payload << @verificationIntervals.select {|key, val| key.value?(word)}[0]
  #   end
  #
  #   puts @payload
  #   @verification.verify("https://dl.dropboxusercontent.com/s/9sjcew8ficzk8u6/Audio%20Track-7.wav?dl=0", @payload)
  #   puts @verification.status
  #   expect(@verification.status).to eq(false)
  # end
  #
  # it 'fails collin' do
  #   @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/xrk2t53hmnh0kun/Audio%20Track-8.wav?dl=0", :num_words => 3})
  #   @verificationIntervals = []
  #   puts @verification.status
  #   @verificationAnalysis.results.each_with_index do |interval, index|
  #     interval['phrase'] = @phrase[index]
  #     @verificationIntervals << interval
  #   end
  #
  #   @payload = []
  #   @verification.status["phrases"].each do |word|
  #     @payload << @verificationIntervals.select {|key, val| key.value?(word)}[0]
  #   end
  #
  #   puts @payload
  #   @verification.verify("https://dl.dropboxusercontent.com/s/xrk2t53hmnh0kun/Audio%20Track-8.wav?dl=0", @payload)
  #   puts @verification.status
  #   expect(@verification.status).to eq(false)
  # end
  #
  # it 'fails collin' do
  #   @verificationAnalysis = Knurld::Analysis.new({:audioUrl => "https://dl.dropboxusercontent.com/s/onxg1e6psqybz38/Audio%20Track-9.wav?dl=0", :num_words => 3})
  #   @verificationIntervals = []
  #   puts @verification.status
  #   @verificationAnalysis.results.each_with_index do |interval, index|
  #     interval['phrase'] = @phrase[index]
  #     @verificationIntervals << interval
  #   end
  #
  #   @payload = []
  #   @verification.status["phrases"].each do |word|
  #     @payload << @verificationIntervals.select {|key, val| key.value?(word)}[0]
  #   end
  #
  #   puts @payload
  #   @verification.verify("https://dl.dropboxusercontent.com/s/onxg1e6psqybz38/Audio%20Track-9.wav?dl=0", @payload)
  #   puts @verification.status
  #   expect(@verification.status).to eq(false)
  # end
end
