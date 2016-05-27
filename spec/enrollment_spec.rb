require 'spec_helper'

describe Knurld::Enrollment do
  before(:all) do
    @appmodel = Knurld::AppModel.new
    @consumer = Knurld::Consumer.new({:gender => "male", :username => ('a'..'z').to_a.shuffle[0,8].join, :password => "TESTUSER"})
    @file_url = "https://www.dropbox.com/s/jghxwhd82a41gi6/3309643979.wav"
  end

  describe 'intialize' do
    it 'requires appmodel and consumer' do
      expect { Knurld::Enrollment.new({:appmodel => @appmodel}) }.to raise_error(KeyError)
      expect { Knurld::Enrollment.new({:consumer => @consumer}) }.to raise_error(KeyError)
    end

    it 'typechecks them to be Knurld SDK types' do
      expect{ Knurld::Enrollment.new({:appmodel => @appmodel, :consumer => "consumer"}) }.to raise_error(TypeError)
      expect{ Knurld::Enrollment.new({:appmodel => "appmodel", :consumer => @consumer}) }.to raise_error(TypeError)
    end

    it 'sets href and id' do
      enrollment = Knurld::Enrollment.new({:appmodel => @appmodel, :consumer => @consumer})
      expect(enrollment.href).to_not be_nil
      expect(enrollment.id).to_not be_nil
    end
  end

  describe 'populate' do
    it 'enforces typing' do
      @enrollment = Knurld::Enrollment.new({:appmodel => @appmodel, :consumer => @consumer})
      expect{ @enrollment.populate(1, [{}]) }.to raise_error(TypeError)
      expect{ @enrollment.populate("users/tom/file.wav", "whoops") }.to raise_error(TypeError)
    end

    it 'returns href upon success' do
      #TODO write analysis section and perform testing then
      # expect{ @enrollment.populate(:file_url => @file_url, )}
    end
  end

  describe 'complete_or_status' do

  end

  describe 'destroy' do
  end
end
