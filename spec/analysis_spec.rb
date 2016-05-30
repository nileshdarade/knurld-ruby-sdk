require 'spec_helper'

describe Knurld::Analysis do
  describe 'initialize' do
    it 'requires audioURL and num_words' do
      expect { Knurld::Analysis.new({:num_words => 3}) }.to raise_error(KeyError)
      expect { Knurld::Analysis.new({:audioUrl => "https"}) }.to raise_error(KeyError)
    end

    it 'only accepts string and fixnum' do
      expect {Knurld::Analysis.new({:num_words => "3", :audioUrl => "https"})}.to raise_error(TypeError)
      expect {Knurld::Analysis.new({:num_words => 3, :audioUrl => 3})}.to raise_error(TypeError)
    end

    it 'sets taskname and taskstatus' do
      analysis = Knurld::Analysis.new({:num_words => 9, :audioUrl => "https://dl.dropboxusercontent.com/s/lqrydu915bvag3k/6561423480.wav?dl=0"})
      expect(analysis.taskName).to_not be_nil
      expect(analysis.taskStatus).to_not be_nil
    end
  end

  describe 'results' do
    it 'returns a result, not nil' do
      @analysis = Knurld::Analysis.new({:num_words => 9, :audioUrl => "https://dl.dropboxusercontent.com/s/lqrydu915bvag3k/6561423480.wav?dl=0"})
      @results = @analysis.results
      puts @results
      expect(@results).to_not be_nil
    end
  end
end
