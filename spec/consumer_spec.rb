require 'spec_helper'

describe Knurld::Consumer do
  before(:all) do
    @consumer = Knurld::Consumer.new({:gender => "male", :username => ('a'..'z').to_a.shuffle[0,8].join, :password => "TESTUSER"})
  end

  after(:all) do
    begin
      @consumer.destroy
    rescue => e
      #our user was successfully destroyed in a test
    end
  end

  describe 'initialize' do
    it 'requires gender, username, and password' do
      expect {
        Knurld::Consumer.new({:gender => "male", :username => "blah"})
      }.to raise_error(KeyError)
      expect {
        Knurld::Consumer.new({:password => "password", :username => "username"})
      }.to raise_error(KeyError)
      expect {
        Knurld::Consumer.new({:gender => "male", :password => "password"})
      }.to raise_error(KeyError)
    end

    it 'only accepts strings for all 3 parameters' do
      expect {
        Knurld::Consumer.new({:gender => 1, :username => "username", :password => "password"})
      }.to raise_error(TypeError)
      expect {
        Knurld::Consumer.new({:gender => "male", :username => 1, :password => "password"})
      }.to raise_error(TypeError)
      expect {
        Knurld::Consumer.new({:gender => "male", :username => "username", :password => 1})
      }.to raise_error(TypeError)
    end

    it 'stores href and id' do
      expect(@consumer.href).to_not be_nil
      expect(@consumer.id).to_not be_nil
    end
  end

  describe 'change_password' do
    it 'only accepts strings' do
      expect{@consumer.change_password([1,2,3])}.to raise_error(TypeError)
    end

    it 'updates password' do
      @consumer.change_password("new_password")
      expect(@consumer.password).to eq("new_password")
    end
  end

  describe 'authenticate' do
    it 'produces token upon calling' do
      expect(@consumer.authenticate).to be_a(String)
    end
  end

  #this must be our last test
  describe 'destroy' do
    it 'destroys the @consumer' do
      expect(@consumer.destroy).to be_nil
    end
  end

  describe 'enroll' do
  end
end
