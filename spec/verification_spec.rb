require 'spec_helper'

describe Knurld::Verification do
  before(:all) do
    @appmodel = Knurld::AppModel.new
    @consumer = Knurld::Consumer.new({:gender => "male", :username => ('a'..'z').to_a.shuffle[0,8].join, :password => "TESTUSER"})
    @file_url = "https://www.dropbox.com/s/jghxwhd82a41gi6/3309643979.wav"
  end

  describe 'intialize' do
    it 'requires appmodel and consumer' do
      expect { Knurld::Verification.new({:appmodel => @appmodel}) }.to raise_error(KeyError)
      expect { Knurld::Verification.new({:consumer => @consumer}) }.to raise_error(KeyError)
    end

    it 'typechecks them to be Knurld SDK types' do
      expect{ Knurld::Verification.new({:appmodel => @appmodel, :consumer => "consumer"}) }.to raise_error(TypeError)
      expect{ Knurld::Verification.new({:appmodel => "appmodel", :consumer => @consumer}) }.to raise_error(TypeError)
    end

    it 'sets href and id' do
      verification = Knurld::Verification.new({:appmodel => @appmodel, :consumer => @consumer})
      expect(verification.href).to_not be_nil
      expect(verification.id).to_not be_nil
    end
  end

  describe 'verify' do
  end

  describe 'success_or_status' do
  end
end
