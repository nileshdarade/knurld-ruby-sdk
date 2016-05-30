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
    # https://dl.dropboxusercontent.com/s/wff0r4tgsw4t00k/Audio%20Track-5.wav?dl=0
    #             https://dl.dropboxusercontent.com/s/yy4iz9fiz0yo13a/Audio%20Track-6.wav?dl=0

    @delwin = %w(https://dl.dropboxusercontent.com/s/7fobl3uyrpy410o/Audio%20Track-9.wav?dl=0
                https://dl.dropboxusercontent.com/s/1mnwyhdam8bagpx/Audio%20Track-10.wav?dl=0
                https://dl.dropboxusercontent.com/s/u96phawugcr98td/Audio%20Track.wav?dl=0)

    # @collin = %w(https://dl.dropboxusercontent.com/s/aeioxyj1z7bkcdh/Audio%20Track-2.wav?dl=0
    #             https://dl.dropboxusercontent.com/s/glcpwfcn58zzw3t/Audio%20Track-3.wav?dl=0
    #             https://dl.dropboxusercontent.com/s/fh2afct4qa17qcu/Audio%20Track-4.wav?dl=0
    #             https://dl.dropboxusercontent.com/s/lmnb4kfplfls1gn/Audio%20Track-5.wav?dl=0
    #             https://dl.dropboxusercontent.com/s/jmdvcm0sg57nqlx/Audio%20Track-6.wav?dl=0
    #             https://dl.dropboxusercontent.com/s/nts6nt7w8mdm7ap/Audio%20Track-7.wav?dl=0
    #             https://dl.dropboxusercontent.com/s/hfdrbx4l9hrlwfp/Audio%20Track-8.wav?dl=0
    #             https://dl.dropboxusercontent.com/s/xkgbh7yd232vfb8/Audio%20Track-9.wav?dl=0
    #             https://dl.dropboxusercontent.com/s/pdh93zomyx6rrn5/Audio%20Track.wav?dl=0)

    @delwin.each do |attempt|
      puts attempt
      @verification = Knurld::Verification.new({:appmodel => @appmodel, :consumer => @consumer})
      while @verification.status["phrases"] != ["Boston", "Ivory", "Sweden"]
        @verification = Knurld::Verification.new({:appmodel => @appmodel, :consumer => @consumer})
      end
      @verificationAnalysis = Knurld::Analysis.new({:audioUrl => attempt, :num_words => 3})
      @verificationIntervals = []
      @verificationPhrase = ["Boston", "Ivory", "Sweden"]
      puts @verificationAnalysis.results[""]
      @verificationAnalysis.results["intervals"].each_with_index do |interval, index|
        interval['phrase'] = @verificationPhrase[index]
        @verificationIntervals << interval
      end
      @verification.verify(attempt, @verificationIntervals)
      puts @verification.status
      # expect(@verification.status).to eq(false)
    end
  end
end
